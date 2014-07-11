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

function onAnonymousAuthorization() {
  onSuccessfulAuthorization("/trello/connect");
}

function onUserAuthorization() {
  onSuccessfulAuthorization("/settings/trello/connect");
}

function onSuccessfulAuthorization(url) {
  $(".connect-btn").text("Connecting...");

  var token = Trello.token();

  $.ajax({
    url: url,
    method: "post",
    data: {
      token: Trello.token()
    },
    success: function () {
      self.location = "/boards";
      $(".connect-btn").text("Connection successful. Redirecting...");
    },
    error: function (xhr) {
      FlashMessage.error(xhr.responseText);
      $(".connect-btn").text("Conneciton failed. Try again.");
    }
  });
}