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
  self.location = "/boards?token=" + token;
}