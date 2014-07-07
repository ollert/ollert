var SignupLoginController = function () {
  function initialize() {
    $("#signupTab").on("click", signup);
    $("#newUser").on("click", signup);

    $("#loginTab").on("click", login);
    $("#already").on("click", login);

    $("#signup").on("submit", submit);

    setupResetPasswordModal();
  }

  function setupResetPasswordModal() {
    $("#resetPasswordModal").on("shown.bs.modal", function () {
      $("#username").focus();
    });

    $("#resetPasswordModal").on("hidden.bs.modal", function () {
      $("#email").focus();
    });

    $("#resetPassword").on("submit", resetPassword);
  }

  function submit(e) {
    if ($("#signupTab").hasClass("active")) {
      createUser(e);
    } else {
      loginUser(e);
    }
  }

  function activateSignupTab() {
    $("#email").focus();
    $(".signup-content").show();
    $("#signupStatus").html("");
    $("#signupTab").addClass("active");
  }

  function activateLoginTab() {
    $("#email")[0].focus();
    $(".login-content").show();
    $("#loginStatus").html("");
    $("#loginTab").addClass("active");
  }

  function deactivateSignupTab() {
    $(".signup-content").hide();
    $("#signupTab").removeClass("active");
  }

  function deactivateLoginTab() {
    $(".login-content").hide();
    $("#loginTab").removeClass("active");
  }

  function signup() {
    deactivateLoginTab();
    activateSignupTab();
  }

  function login() {
    deactivateSignupTab();
    activateLoginTab();
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

        $("#signup input").enable();
      }
    });
  }

  function loginUser(e) {
    e.preventDefault();

    var ind = new LoadingIndicator($("#loginStatus"));
    ind.show("Logging In...");

    $("#signup input").disable();

    $.ajax({
      url: "/authenticate",
      method: "POST",
      data: {
        email: $("#email").val(),
        password: $("#password").val()
      },
      success: function (email) {
        ind.success("Successfully logged in. Redirecting...");
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

        $("#signup input").enable();
      }
    });
  }

  function resetPassword(e) {
    e.preventDefault();
    $("#resetPasswordModal").modal('hide');
    $.ajax({
      url: "/account/reset",
      method: "PUT",
      data: {
        username: $("#username").val()
      },
      success: function () {
        FlashMessage.success(
          "You should receive an email containing a link to reset your password within the a few minutes."
        )
      },
      error: function () {
        FlashMessage.error("An error has occurred. Try again later.")
      }
    });
  }

  return {
    init: initialize,
    showSignupContent: signup,
    showLoginContent: login
  };
}();