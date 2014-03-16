function AuthenticateTrelloAlways() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () { onAuthorizeSuccessful(); },
    scope: { write: true, read: true },
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
    scope: { write: true, read: true },
  });
}

function onAuthorizeSuccessful() {
  var token = Trello.token();
  window.location.replace("/boards?token=" + token);
}

function onFailedAuthorization() {
  window.location.replace("/fail");
}
