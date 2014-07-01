var LoadingIndicator = function (element) {
  element.find(".loading-indicator").remove();
  element.append("<span class='loading-indicator'/>");
  this.indicator = element.find(".loading-indicator");
};

LoadingIndicator.prototype = function () {
  var
  error = function (msg) {
    this.indicator.html(msg);
    this.indicator.addClass("loading-error");
  },
    success = function (msg) {
      this.indicator.html(msg);
      this.indicator.addClass("loading-success");
    },
    show = function (msg) {
      this.indicator.append("<img src='../img/spinner.gif'/>");
      this.indicator.append(msg);
    };

  return {
    error: error,
    success: success,
    show: show
  };
}();