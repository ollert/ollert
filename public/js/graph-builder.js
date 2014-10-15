var ProgressChartBuilder = (function () {
  var postInitialLoadCallback = function (data) {
    var parsedData = jQuery.parseJSON(data);

    CfdChartBuilder.build(parsedData.cfd);
    BurnUpDownChartBuilder.buildBurnUp(parsedData.burnup);
    BurnUpDownChartBuilder.buildBurnDown(parsedData.burnup);
  };

  var loadGraphs = function (boardId) {
    var startingList = $("#in-scope label").text().trim()
    var endingList = $("#out-scope label").text().trim()

    $.ajax({
      url: "/boards/" + boardId + "/analysis/progress",
      data: {
        startingList: startingList,
        endingList: endingList,
      },
      success: postInitialLoadCallback,
      error: function (xhr) {
        $("#cfd-spinner").hide();
        $('#burn-up-spinner').hide();
        $('#burn-down-spinner').hide();

        $("#cfd-container").text(xhr.responseText);
        $("#burn-up-container").text(xhr.responseText);
        $("#burn-down-container").text(xhr.responseText);
      }
    });
  };

  var buildAndLoad = function (boardId) {
    loadGraphs(boardId);
  };

  return {
    build: buildAndLoad
  };
}());