var AnalysisController = (function () {
  var _boardId;
  var _boardName;

  var initialize = function (boardId, boardName) {
    _boardId = boardId;
    _boardName = boardName;

    loadCharts();
  };

  var loadCharts = function () {
    WipChartBuilder.build(_boardId);
    LabelCountChartBuilder.build(_boardId);
    CfdChartBuilder.build(_boardId, _boardName);
    StatsBuilder.build(_boardId);
  };

  return {
    init: initialize,
    reload: loadCharts
  }
})();
