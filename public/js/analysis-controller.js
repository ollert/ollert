var AnalysisController = (function () {
  var initialize = function (boardId, boardStates) {
    $("#configure-board-apply").on("click", function () {
      reloadCharts(boardId);
    });

    setupConfigurationModal(boardStates);

    loadCharts(boardId);
  };

  var loadCharts = function (boardId) {
    WipChartBuilder.build(boardId);
    LabelCountChartBuilder.build(boardId);
    ProgressChartBuilder.build(boardId);
    StatsBuilder.build(boardId);
  };

  var reloadCharts = function (boardId) {
    $("#configure-board-modal").modal('hide');

    $('#burn-up-spinner').show();
    $('#burn-up-container').empty();

    $('#burn-down-spinner').show();
    $('#burn-down-container').empty();

    $('#cfd-spinner').show();
    $('#cfd-container').empty();

    loadCharts(boardId);
  }

  var setupConfigurationModal = function (categories) {
    populateListNames($("#in-scope"), $("#in-scope-states"), categories);
    populateListNames($("#out-scope"), $("#out-scope-states"), categories);
  };

  var populateListNames = function (dropDown, menu, categories) {
    menu.empty();
    for (var i = 0; i < categories.length; i++) {
      menu.append(
        "<li role='presentation'><a role='menuitem' tabindex='-1' href='javascript:void(0)'>" +
        categories[i] + "</a></li>")
    }

    $("li a", menu).on('click', function () {
      $("label", dropDown).text($(this).text());
    });
  }

  return {
    init: initialize,
    reload: loadCharts
  }
})();