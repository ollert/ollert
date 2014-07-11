function AuthorizeTrello(expires, onSuccess) {
  Trello.deauthorize();

  Trello.authorize({
    name: "Ollert",
    type: "popup",
    interactive: true,
    expiration: expires,
    persist: false,
    success: onSuccess,
    scope: {
      read: true,
      write: true
    }
  });
}

function onAuthorizeSuccessful() {
  var token = Trello.token();
  self.location = "/boards?token=" + token;
}