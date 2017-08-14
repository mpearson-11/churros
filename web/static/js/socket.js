// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import { Socket } from "phoenix"
import client from 'github-graphql-client';

let socket = new Socket("/socket", { params: { token: window.userToken } })

const hashCode = str => {
  var hash = 0, i, chr;
  if (str.length === 0) return hash;
  for (i = 0; i < str.length; i++) {
    chr   = str.charCodeAt(i);
    hash  = ((hash << 5) - hash) + chr;
    hash |= 0; // Convert to 32bit integer
  }
  return hash;
};

function generateRandAlphaNumStr(len, data) {
  var rdmString = "";
  for( ; rdmString.length < len; rdmString  += Math.random().toString(36).substr(2));
  return  `${hashCode(data)}-${rdmString.substr(0, len)}`;
}

const randomNumber = max => Math.round(max * (Math.random() + 1));

socket.connect({ user_id: randomNumber(99999999999999999) });

// Now that you are connected, you can join channels with a topic:
// let RoomChannel = socket.channel("rooms:lobby", {})
let GithubChannel = socket.channel("github:lobby", {});

const createEvent = (type, ack, response) => {
  const { data } = response;
  const reply = { data, ack };
  return [`github:${type}`, JSON.stringify(reply)];
};

const pushToChannel = (type, ack) => (error, response) => {
  if (!error) {
    const { data } = response;
    const data_response = { data, ack };
    GithubChannel.push(`github:${type}`, JSON.stringify(data_response));
  } else {
    console.log("Error caught!!");
  }
};

GithubChannel.on("message", ({ body }) => {
  if ($("#live-data") && $("#live-data").data("socket-name") === body.type) {
    const ack = generateRandAlphaNumStr(40, JSON.stringify(body.query));
    const pushMessage = pushToChannel(body.type, ack);
    const request = client({ token: body.token, query: body.query }, pushMessage);

    GithubChannel.on(ack, payload => {
      $("#live-data").html(payload.html);
    });
  }
});

GithubChannel.on("refresh_issues", () => {
  if ($("#refresh_issues")) {
    window.location.href = window.location.href;
  }
});

socket.onConnClose(() => { console.log("Closed connection socket") });
socket.onClose(() => {
  console.log("Closed connection socket")
});

GithubChannel.join()
  .receive("ok", resp => { console.log('socket connected.')})
  .receive("error", resp => { console.log("unable to join.") })

export default socket
