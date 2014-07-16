var AnalysisController = (function () {
  var loadCharts = function (boardId, boardName) {
    WipChartBuilder.build(boardId);
    LabelCountChartBuilder.build(boardId);
    CfdChartBuilder.build(boardId, boardName);
    StatsBuilder.build(boardId);
  }

  return {
    init: loadCharts
  }
}());