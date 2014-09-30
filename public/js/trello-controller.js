var TrelloController = (function () {
  var authorize = function (callback) {
    Trello.deauthorize();
    Trello.clearReady();

    Trello.authorize({
      name: "Ollert",
      type: "popup",
      interactive: true,
      expiration: "never",
      persist: false,
      success: callback || onSuccessfulAuthorization,
      scope: {
        read: true,
        write: true,
        account: true
      }
    });
  };

  var onSuccessfulAuthorization = function (url) {
    $(".connect-btn").text("Connecting...");

    $.ajax({
      url: "/trello/connect",
      method: "put",
      data: {
        token: Trello.token()
      },
      success: function () {
        $(".connect-btn").text("Connection successful. Redirecting...");
        self.location = "/boards";
      },
      error: function (xhr, textStatus, errorThrown) {
        if (xhr.responseText) {
          FlashMessage.error(xhr.responseText);
          $(".connect-btn").text("Connection failed. Try again.");
        }
      }
    });
  };

  return {
    authorize: authorize
  };
}());