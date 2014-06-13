var Analyzer = function(boardId) {
  this.boardId = boardId;
}

Analyzer.prototype.loadCharts = function() {
  this.loadWipChart(this.boardId);
  this.loadCfdChart(this.boardId);
  this.loadStats(this.boardId);
  this.loadLabelCount(this.boardId);
}

Analyzer.prototype.loadWipChart = function() {
  $.get("/boards/" + this.boardId + "/data", function(data) {
    $('#wip-spinner').hide();
    var theData = jQuery.parseJSON(data);
    var wip_data = new wipChartData();
    wip_data.lists = theData.wipcategories;
    wip_data.counts = [{
      name: "Cards in List",
      showInLegend: false,
      data: theData.wipdata
    }];
    var wc = new wipChart(wip_data);
    wc.buildChart();
  });
}

Analyzer.prototype.loadCfdChart = function() {
  $.get("/boards/" + this.boardId + "/cfd", function(data) {
    $('#cfd-spinner').hide();

    var theData = jQuery.parseJSON(data);
    var cfdData = new cfdChartData();
    var cc = new cfdChart({
      data: theData.cfddata,
      dates: theData.dates,
      boardName: "Ollert"
    });
    cc.buildChart();
  });
}

Analyzer.prototype.loadStats = function() {
  $.get("/boards/" + this.boardId + "/stats", function(data) {
    $.each($('.stats-spinner'), function(i, item) {
      $(item).hide();
    });

    var theData = jQuery.parseJSON(data);
    $('#avg_members_per_card').text(theData.avg_members_per_card);
    $('#avg_cards_per_member').text(theData.avg_cards_per_member);
    $('#list_with_most_cards_name').text(theData.list_with_most_cards_name);
    $('#list_with_most_cards_count').text(theData.list_with_most_cards_count);
    $('#list_with_least_cards_name').text(theData.list_with_least_cards_name);
    $('#list_with_least_cards_count').text(theData.list_with_least_cards_count);
    $('#board_members_count').text(theData.board_members_count);
    $('#card_count').text(theData.card_count);
    $('#oldest_card_name').text(theData.oldest_card_name);
    $('#oldest_card_age').text(theData.oldest_card_age);
    $('#newest_card_name').text(theData.newest_card_name);
    $('#newest_card_age').text(theData.newest_card_age);
  });
}

Analyzer.prototype.loadLabelCount = function() {
  $.get("/boards/" + this.boardId + "/labelcounts", function(data) {
    $('#label-count-spinner').hide();

    var theData = jQuery.parseJSON(data);

    var lb_data = new labelCountChartData();
    lb_data.labels = theData.labels;
    lb_data.counts = theData.counts;
    lb_data.colors = theData.colors;
    var labelCount = new labelCountChart(lb_data);
    labelCount.buildChart();
  });
}