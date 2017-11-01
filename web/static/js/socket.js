// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import { Socket } from "phoenix"
import client from 'github-graphql-client';
import BoidsCanvas from './boids-canvas';

let socket = new Socket("/socket", { params: { token: window.userToken } })

var options = {
  background: '#ecf0f1',
  density: 'medium',
  speed: 'medium',
  interactive: true,
  mixedSizes: true,
  boidColours: ["#34495e", "#e74c3c", '#2ecc71', '#9b59b6', '#f1c40f', '#1abc9c']
};

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

const hasProject = (body, liveData) => {
  const socketName = liveData.data("socket-name");

  if (body.number && body.team_name) {
      return socketName === `${body.type}-${body.team_name}-${body.number}`;
  } else {
    return false;
  }
};

const activateWatchedCard = (cardElement) => {
  const card = $(cardElement);
  card.addClass('custom-box');
};

const loadWatchedData = () => {
  const liveData = $("#live-data");
  const elements = $("[data-socket-card-activated]");

  const canvasDiv = document.getElementById('boids-canvas');
  const boidsCanvas = new BoidsCanvas(canvasDiv, options);

  if (elements.length) {
    elements.each((index, selectedElement) => {
      if ($(selectedElement).data("socket-card-activated") === true) {
        activateWatchedCard(selectedElement);
      }
    });
  }
};

GithubChannel.on("message", ({ body }) => {
  const liveData = $("#live-data");
  const socketName = liveData.data('socket-name');

  if (hasProject(body, liveData) || socketName === body.type) {
    const ack = generateRandAlphaNumStr(40, JSON.stringify(body.query));
    const pushMessage = pushToChannel(body.type, ack);
    const request = client({ token: body.token, query: body.query }, pushMessage);

    GithubChannel.on(ack, payload => {
      liveData.html(payload.html);
      if ($("[data-project-watch]").length > 0) {
        setTimeout(() => {
            loadWatchedData();
        }, 250);
      }
    });
  }
});

GithubChannel.on("refresh_issues", () => {
  if ($("#refresh_issues").length >= 1 ) {
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

export default socket;
