var AnalysisController = (function () {
  var _boardId;
  var _boardName;

  var initialize = function (boardId, boardName) {
    _boardId = boardId;
    _boardName = boardName;

    loadCharts();
  };

  var loadCharts = function (options) {
    WipChartBuilder.build(_boardId);
    LabelCountChartBuilder.build(_boardId);
    CfdChartBuilder.init(_boardId, _boardName);
    CfdChartBuilder.build(options);
    StatsBuilder.build(_boardId, options);
  };

  return {
    init: initialize,
    reload: loadCharts
  }
})();
