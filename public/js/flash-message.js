var FlashMessage = function () {
  function error(msg) {
    flash("alert-danger");
  }

  function success(msg) {
    flash("alert-success");
  }

  function info(msg) {
    flash("alert-info");
  }

  function warning(msg) {
    flash("alert-warning");
  }

  function flash(classes) {
    $("#flash").remove();

    $("#mainContent").prepend(
      "<div id='flash' class='row alert " + classes +
      "''><div class='container'>Email sent</div></div>"
    );
  }

  return {
    error: error,
    success: success
  }
}();