var SettingsController = function () {
  function initialize(connected) {
    if (connected) {
      $("#trello-disconnect").show();
    } else {
      $("#trello-connect").show();
    }

    $("#trello-disconnect").on("click", disconnectFromTrello);
    $("#trello-connect").on("click", connectToTrello);

    $("#update-email").on("submit", updateEmail);
    $("#update-password").on("submit", updatePassword);

    $("#delete-account").on("submit", deleteAccount);
  }

  function updateEmail(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#email-status"));
    ind.show("Saving...");

    $("#update-email input").disable();

    $.ajax({
      url: "/settings/email",
      data: {
        email: $("#email").val()
      },
      method: "PUT",
      success: function (email) {
        ind.success("Your new email is <b>" + email + "</b>. Use this to log in.");
      },
      error: function (xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function () {
        $("#update-email input").enable();
      }
    });
  }

  function updatePassword(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#password-status"));
    ind.show("Saving...");

    $("#update-password input").disable();

    $.ajax({
      url: "/settings/password",
      data: {
        current_password: $("#current-password").val(),
        new_password: $("#new-password").val(),
        confirm_password: $("#confirm-password").val()
      },
      method: "PUT",
      success: function (email) {
        ind.success("Password updated.");

        $("#current-password").val("");
        $("#new-password").val("");
        $("#confirm-password").val("");
      },
      error: function (xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function () {
        $("#update-password input").enable();
      }
    });
  }

  function disconnectFromTrello() {
    var ind = new LoadingIndicator($("#trello-connect-status"));
    ind.show("Saving...");

    $("#trello-disconnect").disable();
    $.ajax({
      url: "/settings/trello/disconnect",
      method: "PUT",
      success: function () {
        ind.success("Successfully disconnected.");

        $("#trello-disconnect").hide();
        $("#trello-connect").show();
      },
      error: function (xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function () {
        $("#trello-disconnect").enable();
        Ollert.loadBoards();
      }
    });
  }

  function connectToTrello() {
    var onSuccess = function () {
      var ind = new LoadingIndicator($("#trello-connect-status"));
      ind.show("Saving...");

      $("#trello-connect").disable();
      $.ajax({
        url: "/settings/trello/connect",
        data: {
          token: Trello.token()
        },
        method: "PUT",
        success: function (username) {
          ind.success("Successfully connected.");
          $("#trello-connect").hide();
          $("#trello-disconnect").show();

          $("#trello-disconnect").html("Disconnect Trello user <b>" + username + "</b>")
        },
        error: function (xhr) {
          ind.error(
            xhr.responseText +
            " (" +
            xhr.status +
            ": " +
            xhr.statusText +
            ")"
          );
        },
        complete: function () {
          $("#trello-connect").enable();
          Ollert.loadBoards();
        }
      });
    }
    TrelloController.authorizeUser(onSuccess);
  }

  function deleteAccount(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#delete-account-status"));
    ind.show("Deleting...");

    $("#delete-account input").disable();

    $.ajax({
      url: "/settings/delete",
      data: {
        iamsure: $("#i-am-sure")[0].checked,
        _method: "DELETE"
      },
      method: "POST",
      success: function () {
        ind.success("Account deleted. Redirecting...");
        self.location = "/";
      },
      error: function (xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function () {
        $("#delete-account input").enable();
      }
    });
  }

  return {
    init: initialize
  };
}();
