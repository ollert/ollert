var ProgressChartBuilder = (function() {
  var displayData = function(data) {
    var parsedData = jQuery.parseJSON(data);

    CfdChartBuilder.build(parsedData.cfd);
    BurnUpDownChartBuilder.buildBurnUp(parsedData.burnup);
    BurnUpDownChartBuilder.buildBurnDown(parsedData.burnup);
  };

  var resetCharts = function() {
    $('#burn-up-spinner').show();
    $('#burn-up-container').empty();

    $('#burn-down-spinner').show();
    $('#burn-down-container').empty();

    $('#cfd-spinner').show();
    $('#cfd-container').empty();
  };

  var build = function(boardId, token, startingList, endingList, showArchived) {
    resetCharts();

    $.ajax({
      url: "/api/v1/progress/" + boardId,
      data: {
        startingList: startingList,
        endingList: endingList
      },
      headers: {"Authorization": token},
      success: displayData,
      error: function(xhr) {
        $("#cfd-spinner").hide();
        $('#burn-up-spinner').hide();
        $('#burn-down-spinner').hide();

        $("#cfd-container").text(xhr.responseText);
        $("#burn-up-container").text(xhr.responseText);
        $("#burn-down-container").text(xhr.responseText);
      }
    });
  };

  return {
    build: build
  };
}());
