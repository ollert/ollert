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
    // loadSimpleBoards('Work in progress');
    var boardData = data['data'];
    var menus = $('.my-boards');

    console.log(data)
    var boardItem;
    for (var boardName in boardData) {
      var organization = boardData[boardName],
          organizationBoards = $("<ul/>");
      for (var j = 0; j < organization.length; ++j) {
        var board = organization[j]
        item = $("<li/>", {
          role: "presentation"
        });
        item.append($("<a href=\"/boards/" + board.id + "\">" + board.name + "</a>"));
        organizationBoards.append(item);
      }
      var section = $("<li role=\"presentation\"><b>" + boardName + "</b></li>").append(organizationBoards)
      $("#config-drawer-board-list").append(section);
    }


    for (var organization in boardData) {
      if (boardData.hasOwnProperty(organization)) {
        menus.each(function() {
          var element = $("<li>" + organization + "</li>");
          element.addClass('divider');
          element.addClass('divider-section');

          $(this).append(element);
        });

        for (var i = 0; i < boardData[organization].length; i++) {
          var board = boardData[organization][i];
          menus.each(function() {
            var element = $("<li></li>");
            var link = $("<a>" + board['name'] + "</a>");
            link.addClass('btn');
            link.addClass('btn-link');
            link.attr('href', '/boards/' + board['id']);

            element.append(link);
            $(this).append(element);
          });
        }
      }
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
