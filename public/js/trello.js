function AuthenticateTrelloAlways() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () { onAuthorizeSuccessful(); },
    scope: { read: true },
  });
}

function AuthenticateTrelloOneHour() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "1hour",
    persist: false,
    success: function () { onAuthorizeSuccessful(); },
    scope: { read: true },
  });
}

function AuthenticateTrelloFromSettings() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () { onAuthorizeSuccessfulFromSettings(); },
    scope: { read: true },
  });
}

function onAuthorizeSuccessfulFromSettings() {
  var token = Trello.token();
  window.location.replace("/settings/trello/connect?token=" + token);
}

function onAuthorizeSuccessful() {
  var token = Trello.token();
  window.location.replace("/boards?token=" + token);
}

function onFailedAuthorization() {
  window.location.replace("/fail");
}
