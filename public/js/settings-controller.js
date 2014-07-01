var SettingsController = function () {
  function initialize(connected) {
    if (connected) {
      $("#trelloDisconnect").show();
    } else {
      $("#trelloConnect").show();
    }

    $("#trelloDisconnect").on("click", disconnectFromTrello);
    $("#trelloConnect").on("click", connectToTrello);
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

  return {
    init: initialize
  }
}();