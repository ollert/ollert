var Ollert = (function () {
  var loadBoards = function () {
    clearBoards();

    $.ajax({
      url: "/boards",
      headers: { Accept: 'application/json' },
      success: loadBoardsCallback,
      statusCode: {
        400: function () { loadSimpleBoards('No Boards'); }
      },
      error: function (request, status, error) {
        if (request.status != 400) {
          loadSimpleBoards('Error. Try reloading!');
        }
      }
    });
  };

  var clearBoards = function () {
    var menus = $('.my-boards');

    menus.each(function () {
      $(this).empty();
    });
  };

  var loadSimpleBoards = function (text) {
    var menus = $('.my-boards');
    menus.each(function () {
      var element = $("<li>" + text + "</li>");
      element.addClass('divider');
      element.addClass('divider-section');

      $(this).append(element);
    });
  };

  var loadBoardsCallback = function (data) {
    var boardData = data['data'];
    var menus = $('.my-boards');

    for (var organization in boardData) {
      if (boardData.hasOwnProperty(organization)) {
        menus.each(function () {
          var element = $("<li>" + organization + "</li>");
          element.addClass('divider');
          element.addClass('divider-section');

          $(this).append(element);
        });

        for (var i = 0; i < boardData[organization].length; i++) {
          var board = boardData[organization][i];
          menus.each(function () {
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

  return {
    loadBoards: loadBoards
  };
})();
