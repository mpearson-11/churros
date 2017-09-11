defmodule Churros.Github.UtilController do
  use Churros.Web, :controller

  def organisation_issues(org, repo) do
    "query {
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          issues(first: 100) {
            nodes {
              body
            }
          }
        }
      }
    }"
  end

  def organisation_teams(org) do
    "query {
      organization(login: \"#{org}\") {
        name
        teams(first: 100) {
          nodes {
            name
          }
        }
      }
    }"
  end

  def organisation_members(org) do
    "query { 
      organization(login: \"#{org}\") {
        members(first: 100) {
          nodes {
            name
          }
        }
      }
    }"
  end

  def watched_project(org, repo, project) do
    "query { 
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          project(number: #{project}) {
            name
            number
            columns(first: 3) {
              nodes {
                name
                cards(first: 20) {
                  nodes {
                    note
                    content {
                      ... on PullRequest {
                        assignees(first: 10) {
                          nodes {
                            avatarUrl
                            login
                          }
                        }
                        body
                        title
                        number
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }"
  end

  def project(org, repo, project) do
    "query { 
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          project(number: #{project}) {
            body
            bodyHTML
            closedAt
            createdAt
            id
            name
            number
            columns(first: 7) {
              nodes {
                name
                cards(first: 20) {
                  nodes {
                    note
                    content {
                      ... on PullRequest {
                        assignees(first: 10) {
                          nodes {
                            avatarUrl
                            login
                          }
                        }
                        body
                        title
                        number
                        labels(first: 5) {
                          nodes {
                            name
                            color
                          }
                        }
                      }
                      ... on Issue {
                        assignees(first: 10) {
                          nodes {
                            avatarUrl
                            login
                          }
                        }
                        body
                        title
                        number
                        labels(first: 5) {
                          nodes {
                            name
                            color
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }"
  end

  def projects(org, repo) do
    "query { 
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          projects(first: 8, states: OPEN) {
            nodes {
              body
              bodyHTML
              closedAt
              createdAt
              id
              name
              number
              columns(first: 7) {
                nodes {
                  name
                  cards(first: 20) {
                    nodes {
                      note
                      content {
                        ... on PullRequest {
                          assignees(first: 10) {
                            nodes {
                              avatarUrl
                              login
                            }
                          }
                          body
                          title
                          number
                          labels(first: 5) {
                            nodes {
                              name
                              color
                            }
                          }
                        }
                        ... on Issue {
                          assignees(first: 10) {
                            nodes {
                              avatarUrl
                              login
                            }
                          }
                          body
                          title
                          number
                          labels(first: 5) {
                            nodes {
                              name
                              color
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }"
  end
  
  def milestones(org, repo) do
    "query { 
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          milestones(first: 5) {
            nodes {
              title
              number
              description
              dueOn
            }
          }
        }
      }
    }"
  end

  def all(org, repo) do
    "query { 
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          projects(first: 100) {
            nodes {
              body
              bodyHTML
              closedAt
              createdAt
              id
              name
              number
              columns(first: 5) {
                nodes {
                  cards(first: 100) {
                    nodes {
                      content{
                        __typename
                      }
                      note
                      column {
                        name
                        id
                      }
                    }
                  }
                }
              }
              
            }
          }
          milestones(first: 5) {
            nodes {
              title
              number
              description
              dueOn
            }
          }
          issues(first: 100) {
            nodes {
              id
              assignees(first: 5) {
                nodes {
                  avatarUrl
                  name
                }
              }
              labels(first: 5) {
                nodes {
                  name
                }
              }
              state
              updatedAt
              createdAt
            }
          }
        }
      }
    }"
  end

  def organisation_issues_timeline(org, repo) do
    "{
      repositoryOwner(login: \"#{org}\") {
        repository(name: \"#{repo}\") {
          issues(first: 100) {
            nodes {
              bodyHTML
              timeline(last: 7) {
                nodes {
                  ... on AssignedEvent {
                    createdAt
                    actor {
                      ... on User {
                        avatarUrl
                        login
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }"
  end
end

# Type queries into this side of the screen, and you will 
# see intelligent typeaheads aware of the current GraphQL type schema, 
# live syntax, and validation errors highlighted within the text.

# We'll get you started with a simple query showing your username!
# Type queries into this side of the screen, and you will 
# see intelligent typeaheads aware of the current GraphQL type schema, 
# live syntax, and validation errors highlighted within the text.

# We'll get you started with a simple query showing your username!
