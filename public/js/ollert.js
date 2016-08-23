var Ollert = (function() {
  var initDrawer = function() {
    refreshDrawer();
    $("body").toggleClass("has-drawer");
    var hammertime = new Hammer($("body")[0]);
    hammertime.on('swipeleft', function(ev) {
      if ($("#config-drawer").hasClass("open")) {
        $(".drawer-controls a").click();
      }
    });
    hammertime.on('swiperight', function(ev) {
      if (!$("#config-drawer").hasClass("open")) {
        $(".drawer-controls a").click();
      }
    });

    tempNotifyUsersAboutDrawer();
  };

  var tempNotifyUsersAboutDrawer = function () {
    if (window['localStorage'] && window['localStorage'].getItem('hasAcknowledgedDrawer') != "true") {
      setTimeout(function() {
        $(".drawer-controls a").addClass("shake");
      }, 2500);
    }

    $(".drawer-controls a").on("click", function() {
      window['localStorage'].setItem('hasAcknowledgedDrawer', true);
    });
  };

  var refreshDrawer = function () {
    loadBoards();
  };

  var loadBoards = function() {
    resetBoards("Loading boards, please wait...");
    $.ajax({
      url: "/boards.json",
      method: "get",
      headers: {
        Accept: 'application/json'
      },
      dataType: "json",
      success: loadBoardsCallback,
      error: function(request, status, error) {
        resetBoards(request.status === 400 ? 'No boards' : 'Error. Try reloading!');
      }
    });
  };

  var resetBoards = function(text) {
    if (text) {
      $("#config-drawer-board-list").append($("<span>" + text + "</span>"));
    } else {
      $("#config-drawer-board-list").empty();
    }
  };

  var loadBoardsCallback = function(data) {
    resetBoards();
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
    initDrawer: initDrawer,
    refreshDrawer: refreshDrawer,
    loadAvatar: loadAvatar
  };
})();
