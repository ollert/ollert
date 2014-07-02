var SignupController = function () {
  function initialize() {
    $("#signup").on("submit", createUser);
  }

  function createUser(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#signupStatus"));
    ind.show("Registering...");

    $("#signup input").disable();

    $.ajax({
      url: "/signup",
      data: {
        email: $("#email").val(),
        password: $("#password").val(),
        agreed: $("#agreed")[0].checked
      },
      method: "POST",
      success: function (email) {
        ind.success("Successfully registered. Redirecting...");
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
        $("#signup input").enable();
      }
    });
  }

  return {
    init: initialize
  };
}();