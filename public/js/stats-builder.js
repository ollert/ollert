var StatsBuilder = (function() {
  var buildBoxes = function(stats) {
    $('#board-members-count').text(stats.board_members_count);
    $('#card-count').text(stats.card_count);
    $('#avg-members-per-card').text(stats.avg_members_per_card);
    $('#avg-cards-per-member').text(stats.avg_cards_per_member);

    $('#list-with-most-cards-name').text(stats.list_with_most_cards_name);
    $('#list-with-most-cards-name').attr("title", stats.list_with_most_cards_name);
    $('#list-with-most-cards-count').text(stats.list_with_most_cards_count);
    $('#list-with-least-cards-name').text(stats.list_with_least_cards_name);
    $('#list-with-least-cards-name').attr("title", stats.list_with_least_cards_name);
    $('#list-with-least-cards-count').text(stats.list_with_least_cards_count);

    $('#oldest-card-name').text(stats.oldest_card_name);
    $('#oldest-card-name').attr("title", stats.oldest_card_name);
    $('#oldest-card-age').text(stats.oldest_card_age);
    $('#newest-card-name').text(stats.newest_card_name);
    $('#newest-card-name').attr("title", stats.newest_card_name);
    $('#newest-card-age').text(stats.newest_card_age);
  }

  var load = function(boardId, token, showArchived) {
    $.ajax({
      url: "/api/v1/stats/" + boardId,
      data: {
        show_archived: showArchived
      },
      headers: {"Authorization": token},
      success: function(data) {
        $(".stats-spinner").hide();

        buildBoxes(jQuery.parseJSON(data));
      },
      error: function(xhr) {
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
