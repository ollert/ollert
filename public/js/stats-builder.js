var StatsBuilder = (function () {
  var buildBoxes = function (stats) {
    $('#board_members_count').text(stats.board_members_count);
    $('#card_count').text(stats.card_count);
    $('#avg_members_per_card').text(stats.avg_members_per_card);
    $('#avg_cards_per_member').text(stats.avg_cards_per_member);

    $('#list_with_most_cards_name').text(stats.list_with_most_cards_name);
    $('#list_with_most_cards_name').attr("title", stats.list_with_most_cards_name);
    $('#list_with_most_cards_count').text(stats.list_with_most_cards_count);
    $('#list_with_least_cards_name').text(stats.list_with_least_cards_name);
    $('#list_with_least_cards_name').attr("title", stats.list_with_least_cards_name);
    $('#list_with_least_cards_count').text(stats.list_with_least_cards_count);

    $('#oldest_card_name').text(stats.oldest_card_name);
    $('#oldest_card_name').attr("title", stats.oldest_card_name);
    $('#oldest_card_age').text(stats.oldest_card_age);
    $('#newest_card_name').text(stats.newest_card_name);
    $('#newest_card_name').attr("title", stats.newest_card_name);
    $('#newest_card_age').text(stats.newest_card_age);
  }

  var load = function (boardId) {
    $.ajax({
      url: "/boards/" + boardId + "/analysis/stats",
      success: function (data) {
        $(".stats-spinner").hide();

        buildBoxes(jQuery.parseJSON(data));
      },
      error: function (xhr) {
        $(".stats-spinner").hide();

        $(".stat-value").css({
          "font-size": "2em"
        });
        $(".stat-value").text(xhr.responseText);
      }
    });
  }

  return {
    build: load
  }
})();