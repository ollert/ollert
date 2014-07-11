var TrelloController = (function () {
  var anonymous = function () {
    authorize("1hour", anonymousSuccess);
  }

  var user = function (callback) {
    authorize("never", callback || userSuccess);
  }

  var authorize = function (expires, callback) {
    Trello.deauthorize();
    Trello.clearReady();

    Trello.authorize({
      name: "Ollert",
      type: "popup",
      interactive: true,
      expiration: expires,
      persist: false,
      success: callback,
      scope: {
        read: true,
        write: true
      }
    });
  }

  var anonymousSuccess = function () {
    onSuccessfulAuthorization("/trello/connect");
  }

  var userSuccess = function () {
    onSuccessfulAuthorization("/settings/trello/connect");
  }

  var onSuccessfulAuthorization = function (url) {
    $(".connect-btn").text("Connecting...");

    $.ajax({
      url: url,
      method: "put",
      data: {
        token: Trello.token()
      },
      success: function () {
        self.location = "/boards";
        $(".connect-btn").text("Connection successful. Redirecting...");
      },
      error: function (xhr) {
        FlashMessage.error(xhr.responseText);
        $(".connect-btn").text("Connection failed. Try again.");
      }
    });
  }

  return {
    authorize: authorize,
    authorizeAnonymous: anonymous,
    authorizeUser: user
  };
}());