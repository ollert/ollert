var AnalysisController = (function() {
  var initialize = function(boardId, boardStates, token) {
    setupConfigurationModal(boardId, boardStates, token);
    loadCharts(boardId, token);
  };

  var getCurrentStartingList = function() {
    return $("#in-scope label").text().trim();
  };

  var getCurrentEndingList = function() {
    return $("#out-scope label").text().trim();
  };

  var loadCharts = function(boardId, token) {
    WipChartBuilder.build(boardId, token);
    StatsBuilder.build(boardId, token);
    LabelCountChartBuilder.build(boardId, token);
    ProgressChartBuilder.build(boardId, token, getCurrentStartingList(), getCurrentEndingList());
  };

  var updateListRange = function(boardId, token) {
    $("#configure-board-modal").modal('hide');

    $.ajax({
      url: "/boards/" + boardId,
      type: "put",
      data: {
        startingList: getCurrentStartingList(),
        endingList: getCurrentEndingList()
      }
    });

    ProgressChartBuilder.build(boardId, token, getCurrentStartingList(), getCurrentEndingList());
  };

  var setupConfigurationModal = function(boardId, categories, token) {
    populateListNames($("#in-scope"), $("#in-scope-states"), categories);
    populateListNames($("#out-scope"), $("#out-scope-states"), categories);

    $("#configure-board-apply").on("click", function() {
      updateListRange(boardId, token);
    });
  };

  var populateListNames = function(dropDown, menu, categories) {
    menu.empty();
    for (var i = 0; i < categories.length; i++) {
      menu.append(
        "<li role='presentation'><a role='menuitem' tabindex='-1' href='javascript:void(0)'>" +
        categories[i] + "</a></li>")
    }

    $("li a", menu).on('click', function() {
      $("label", dropDown).text($(this).text());
    });
  };

  return {
    init: initialize
  }
})();