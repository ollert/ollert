var Ollert = (function() {
  var loadBoards = function() {
    $('.my-boards').each(function() {
      $(this).empty();
    });

    $.ajax({
      url: "/boards",
      headers: {
        Accept: 'application/json'
      },
      success: loadBoardsCallback,
      error: function(request, status, error) {
        loadSimpleBoards(request.status === 400 ? 'No boards' : 'Error. Try reloading!');
      }
    });
  };

  var loadSimpleBoards = function(text) {
    var menus = $('.my-boards');
    menus.each(function() {
      var element = $("<li>" + text + "</li>");
      element.addClass('divider');
      element.addClass('divider-section');

      $(this).append(element);
    });
  };

  var loadBoardsCallback = function(data) {
    var boardData = data['data'], boardItem, board, organization, boards;
    for (var orgName in boardData) {
      organization = boardData[orgName];
      organizationBoards = $("<ul/>");
      for (var j = 0; j < organization.length; ++j) {
        board = organization[j];
        item = $("<li/>", {
          role: "presentation"
        });
        item.append($("<a href=\"/boards/" + board.id + "\">" + board.name + "</a>"));
        organizationBoards.append(item);
      }
      var section = $("<li role=\"presentation\"><b>" + orgName + "</b></li>").append(organizationBoards)
      $("#config-drawer-board-list").append(section);
    }
  };

  var loadAvatar = function(gravatar_hash) {
    $(".settings-link > img").attr("src", "http://www.gravatar.com/avatar/" + gravatar_hash + "?s=40");
  };

  return {
    loadBoards: loadBoards,
    loadAvatar: loadAvatar
  };
})();
