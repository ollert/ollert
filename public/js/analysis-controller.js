var AnalysisController = (function () {
  var initialize = function (boardId, boardStates, startingList, endingList, token) {
    setupConfigurationModal(boardId, boardStates, startingList, endingList, token);
    loadCharts(boardId, token);
  };

  var getCurrentList = function (id) {
    return $($("#" + id)[0].selectedOptions).val();
  }

  var getCurrentStartingList = function () {
    return getCurrentList("starting-list");
  };

  var getCurrentEndingList = function () {
    return getCurrentList("ending-list");
  };

  var loadCharts = function (boardId, token) {
    var startOfWork = getCurrentStartingList(),
        endOfWork = getCurrentEndingList();

    WipChartBuilder.build(boardId, token);
    StatsBuilder.build(boardId, token);
    LabelCountChartBuilder.build(boardId, token);
    ProgressChartBuilder.build(boardId, token, startOfWork, endOfWork);
    ListChangesChartBuilder.build(boardId, token, startOfWork, endOfWork);
  };

  var updateListRange = function (boardId, token) {
    var startOfWork = getCurrentStartingList(),
        endOfWork = getCurrentEndingList();

    $("#configure-board-modal").modal('hide');

    $.ajax({
      url: "/boards/" + boardId,
      type: "put",
      data: {
        startingList: startOfWork,
        endingList: endOfWork
      }
    });

    ProgressChartBuilder.build(boardId, token, startOfWork, endOfWork);
    ListChangesChartBuilder.build(boardId, token, startOfWork, endOfWork);
  };

  var setupConfigurationModal = function (boardId, boardLists, startingList, endingList, token) {
    populateDropdown($("#starting-list"), boardLists, startingList);
    populateDropdown($("#ending-list"), boardLists, endingList);

    $("#submit-board-lists").on("click", function () {
      updateListRange(boardId, token);
    });
  };

  var populateDropdown = function (dropdown, boardLists, initial) {
    for (var i = 0; i < boardLists.length; i++) {
      dropdown.append("<option value='" + boardLists[i].id + "'>" + boardLists[i].name + "</option>")
    }

    dropdown.val(initial);
  };

  return {
    init: initialize
  }
})();
