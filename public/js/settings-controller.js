var SettingsController = function() {
  function initialize() {
    $("#trello-connect").on("click", connectToTrello);

    $("#update-email").on("submit", updateEmail);
    $("#email-info").popover();

    $("#delete-account").on("submit", deleteAccount);
  };

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
      success: function(email) {
        ind.success("Your new email is <b>" + email + "</b>. Use this to log in.");
      },
      error: function(xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function() {
        $("#update-email input").enable();
      }
    });
  };

  function connectToTrello() {
    TrelloController.authorize(onSuccessfulConnect);
  };

  var onSuccessfulConnect = function() {
    var ind = new LoadingIndicator($("#trello-connect-status span"));
    ind.show("Saving...");

    $("#trello-connect").disable();
    $.ajax({
      url: "/settings/trello/connect",
      data: {
        token: Trello.token()
      },
      method: "PUT",
      success: function(member) {
        member = jQuery.parseJSON(member);
        ind.success("Currently connected to Trello as <strong>" + member["username"] +
          "</strong>");
        Ollert.loadAvatar(member["gravatar_hash"]);
      },
      error: function(xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function() {
        $("#trello-connect").enable();
        Ollert.loadBoards();
      }
    });
  };

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
      success: function() {
        ind.success("Account deleted. Redirecting...");
        self.location = "/";
      },
      error: function(xhr) {
        ind.error(
          xhr.responseText +
          " (" +
          xhr.status +
          ": " +
          xhr.statusText +
          ")"
        );
      },
      complete: function() {
        $("#delete-account input").enable();
      }
    });
  };

  return {
    init: initialize
  };
}();