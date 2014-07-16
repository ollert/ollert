var AnalysisController = (function () {
  var loadCharts = function (boardId, boardName) {
    loadWipChart(boardId);
    loadLabelCount(boardId);
    loadCfdChart(boardId, boardName);
    loadStats(boardId);
  }

  var loadWipChart = function (boardId) {
    $("#WIP-Container").height($("#WIP-Container").height() - 10);

    $.ajax({
      url: "/boards/" + boardId + "/analysis/wip",
      success: function (data) {
        $('#wip-spinner').hide();
        var parsed = jQuery.parseJSON(data);
        WipChartBuilder.build({
          lists: parsed.wipcategories,
          counts: [{
            name: "Cards in List",
            showInLegend: false,
            data: parsed.wipdata
          }]
        });
      },
      error: function (xhr) {
        $("#wip-spinner").hide();
        $("#WIP-Container").text(xhr.responseText);
      }
    });
  }

  var loadCfdChart = function (boardId, boardName) {
    $("#CFD-Container").height($("#CFD-Container").height() - 10);

    $.ajax({
      url: "/boards/" + boardId + "/analysis/cfd",
      success: function (data) {
        $('#cfd-spinner').hide();

        var parsed = jQuery.parseJSON(data);

        CfdChartBuilder.build({
          data: parsed.cfddata,
          dates: parsed.dates,
          boardName: boardName
        });
      },
      error: function (xhr) {
        $("#cfd-spinner").hide();
        $("#CFD-Container").text(xhr.responseText);
      }
    });
  }

  var loadLabelCount = function (boardId) {
    $("#LabelCount-Container").height($("#LabelCount-Container").height() - 10);

    $.ajax({
      url: "/boards/" + boardId + "/analysis/labelcounts",
      success: function (data) {
        $('#label-count-spinner').hide();

        var parsed = jQuery.parseJSON(data);
        LabelCountChartBuilder.build({
          labels: parsed.labels,
          counts: parsed.counts,
          colors: parsed.colors
        });
      },
      error: function (xhr) {
        $("#label-count-spinner").hide();
        $("#LabelCount-Container").text(xhr.responseText);
      }
    });
  }

  var loadStats = function (boardId) {
    $.ajax({
      url: "/boards/" + boardId + "/analysis/stats",
      success: function (data) {
        $.each($('.stats-spinner'), function (i, item) {
          $(item).hide();
        });

        var theData = jQuery.parseJSON(data);
        $('#board_members_count').text(theData.board_members_count);
        $('#card_count').text(theData.card_count);
        $('#avg_members_per_card').text(theData.avg_members_per_card);
        $('#avg_cards_per_member').text(theData.avg_cards_per_member);

        $('#list_with_most_cards_name').text(theData.list_with_most_cards_name);
        $('#list_with_most_cards_name').attr("title", theData.list_with_most_cards_name);
        $('#list_with_most_cards_count').text(theData.list_with_most_cards_count);
        $('#list_with_least_cards_name').text(theData.list_with_least_cards_name);
        $('#list_with_least_cards_name').attr("title", theData.list_with_least_cards_name);
        $('#list_with_least_cards_count').text(theData.list_with_least_cards_count);

        $('#oldest_card_name').text(theData.oldest_card_name);
        $('#oldest_card_name').attr("title", theData.oldest_card_name);
        $('#oldest_card_age').text(theData.oldest_card_age);
        $('#newest_card_name').text(theData.newest_card_name);
        $('#newest_card_name').attr("title", theData.newest_card_name);
        $('#newest_card_age').text(theData.newest_card_age);
      },
      error: function (xhr) {
        $(".stats-spinner").hide();

        $(".stat-value").css({
          "font-size": "2em"
        });
        $(".analysis-stats").text(xhr.responseText);
      }
    });
  }

  return {
    init: loadCharts
  }
}());