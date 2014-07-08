var FlashMessage = function () {
  function error(msg) {
    flash("alert-danger", msg);
  }

  function success(msg) {
    flash("alert-success", msg);
  }

  function info(msg) {
    flash("alert-info", msg);
  }

  function warning(msg) {
    flash("alert-warning", msg);
  }

  function flash(classes, msg) {
    $("#flash").remove();

    $("#mainContent").prepend(
      "<div id='flash' class='row alert " + classes +
      "''><div class='container'>" + msg + "</div></div>"
    );
  }

  return {
    error: error,
    success: success
  }
}();