var SettingsController = function () {
  function initialize(connected) {
    if (connected) {
      $("#trelloDisconnect").show();
    } else {
      $("#trelloConnect").show();
    }

    $("#trelloDisconnect").on("click", disconnectFromTrello);
    $("#trelloConnect").on("click", connectToTrello);

    $("#updateEmail").on("submit", updateEmail);
    $("#updatePassword").on("submit", updatePassword);

    $("#deleteAccount").on("submit", deleteAccount);
  }

  function updateEmail(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#emailStatus"));
    ind.show("Saving...");

    $("#updateEmail input").disable();

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
        $("#updateEmail input").enable();
      }
    });
  }

  function updatePassword(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#passwordStatus"));
    ind.show("Saving...");

    $("#updatePassword input").disable();

    $.ajax({
      url: "/settings/password",
      data: {
        current_password: $("#current_password").val(),
        new_password: $("#new_password").val(),
        confirm_password: $("#confirm_password").val()
      },
      method: "PUT",
      success: function (email) {
        ind.success("Password updated.");

        $("#current_password").val("");
        $("#new_password").val("");
        $("#confirm_password").val("");
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
        $("#updatePassword input").enable();
      }
    });
  }

  function disconnectFromTrello() {
    var ind = new LoadingIndicator($("#trelloConnectStatus"));
    ind.show("Saving...");

    $("#trelloDisconnect").disable();
    $.ajax({
      url: "/settings/trello/disconnect",
      method: "PUT",
      success: function () {
        ind.success("Successfully disconnected.");

        $("#trelloDisconnect").hide();
        $("#trelloConnect").show();
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
        $("#trelloDisconnect").enable();
      }
    });
  }

  function connectToTrello() {
    var onSuccess = function () {
      var ind = new LoadingIndicator($("#trelloConnectStatus"));
      ind.show("Saving...");

      $("#trelloConnect").disable();
      $.ajax({
        url: "/settings/trello/connect",
        data: {
          token: Trello.token()
        },
        method: "PUT",
        success: function (username) {
          ind.success("Successfully connected.");
          $("#trelloConnect").hide();
          $("#trelloDisconnect").show();

          $("#trelloDisconnect").html("Disconnect Trello user <b>" + username + "</b>")
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
          $("#trelloConnect").enable();
        }
      });
    }
    AuthorizeTrello("never", onSuccess);
  }

  function deleteAccount(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#deleteAccountStatus"));
    ind.show("Deleting...");

    $("#deleteAccount input").disable();

    $.ajax({
      url: "/settings/delete",
      data: {
        iamsure: $("#iamsure")[0].checked
      },
      method: "DELETE",
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
        $("#deleteAccount input").enable();
      }
    });
  }

  return {
    init: initialize
  };
}();