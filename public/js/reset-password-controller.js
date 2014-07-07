var ResetPasswordController = function () {
  function initialize() {
    $("#resetPassword").on("submit", resetPassword);
  }

  function resetPassword(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#resetPasswordStatus"));
    ind.show("Saving...");

    $("#resetPassword input").disable();

    $.ajax({
      url: window.location.pathname,
      method: "post",
      data: {
        password: $("#password").val()
      },
      success: function () {
        ind.success("Password updated. Redirecting...");
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

        $("#resetPassword input").enable();
      }
    });
  }

  return {
    init: initialize
  };
}();