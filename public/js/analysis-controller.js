var AnalysisController = (function () {
  var initialize = function (boardId, boardStates, startingList, endingList, showArchived, token) {
    setupConfigurationModal(boardId, boardStates, startingList, endingList, showArchived, token);
    loadCharts(boardId, token);
  };

  var getCurrentList = function (id) {
    return $("#" + id).val();
  }

  var getCurrentStartingList = function () {
    return getCurrentList("starting-list");
  };

  var getCurrentEndingList = function () {
    return getCurrentList("ending-list");
  };

  var loadCharts = function (boardId, token) {
    var startOfWork = getCurrentStartingList(),
        endOfWork = getCurrentEndingList(),
        showArchived = $("#show-archived").get(0).checked;

    WipChartBuilder.build(boardId, token, showArchived);
    StatsBuilder.build(boardId, token, showArchived);
    LabelCountChartBuilder.build(boardId, token, showArchived);
    ProgressChartBuilder.build(boardId, token, startOfWork, endOfWork, showArchived);
    ListChangesChartBuilder.build(boardId, token, startOfWork, endOfWork, showArchived);
  };

  var updateConfiguration = function (boardId, token) {
    var startOfWork = getCurrentStartingList(),
        endOfWork = getCurrentEndingList(),
        showArchived = $("#show-archived").get(0).checked;

    $("#configure-board-modal").modal('hide');

    $.ajax({
      url: "/boards/" + boardId,
      type: "put",
      data: {
        startingList: startOfWork,
        endingList: endOfWork,
        archived: showArchived
      }
    });

    loadCharts(boardId, token);
  };

  var setupConfigurationModal = function (boardId, boardLists, startingList, endingList, showArchived, token) {
    populateDropdown($("#starting-list"), boardLists, startingList);
    populateDropdown($("#ending-list"), boardLists, endingList);
    $("#show-archived").get(0).checked = showArchived;

    $("#submit-board-lists").on("click", function () {
      updateConfiguration(boardId, token);
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
