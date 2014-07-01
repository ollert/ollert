function AuthenticateTrelloAlways() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () {
      onAuthorizeSuccessful();
    },
    scope: {
      read: true
    },
  });
}

function AuthenticateTrelloOneHour() {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: "1hour",
    persist: false,
    success: function () {
      onAuthorizeSuccessful();
    },
    scope: {
      read: true
    },
  });
}

function AuthorizeTrello(expires, onSuccess) {
  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: expires,
    persist: false,
    success: onSuccess,
    scope: {
      read: true
    },
  });
}

function onAuthorizeSuccessful() {
  var token = Trello.token();
  window.location.replace("/boards?token=" + token);
}