var CfdChartBuilder = (function () {
  var _boardId;
  var _boardName;

  var buildChart = function (data) {
    $('#cfd-container').highcharts("StockChart", {
      chart: {
        type: 'area',
        zoomType: 'x'
      },
      rangeSelector: {
        buttons: [{
          type: 'day',
          count: 1,
          text: '1d'
        }, {
          type: 'week',
          count: 1,
          text: '1w'
        }, {
          type: 'week',
          count: 2,
          text: '2w'
        }, {
          type: 'month',
          count: 1,
          text: '1m'
        }, {
          type: 'month',
          count: 3,
          text: '3m'
        }, {
          type: 'year',
          count: 1,
          text: '1y'
        }, {
          type: 'all',
          text: 'All'
        }],
        selected: 3
      },
      title: {
        text: 'Cumulative Flow Diagram'
      },
      subtitle: {
        text: 'CFD'
      },
      xAxis: {
        minRange: 24 * 3600 * 1000, // one day
        tickmarkPlacement: 'on',
        title: {
          enabled: false
        }
      },
      yAxis: {
        floor: 0,
        title: {
          text: 'Cards'
        },
        labels: {}
      },
      tooltip: {
        shared: true,
        valueSuffix: ' cards'
      },
      plotOptions: {
        area: {
          stacking: 'normal',
          lineColor: '#666666',
          lineWidth: 1,
          marker: {
            lineWidth: 1,
            lineColor: '#666666'
          }
        }
      },
      credits: {
        enabled: false
      },
      series: data.cfddata
    });
  };

  var postInitialLoadCallback = function (data) {
    $('#cfd-spinner').hide();

    var container = $("#cfd-container");
    container.height(container.height() - 10);

    var parsedData = jQuery.parseJSON(data);

    buildChart(parsedData);
  };

  var load = function () {
    $.ajax({
      url: "/boards/" + _boardId + "/analysis/cfd",
      success: postInitialLoadCallback,
      error: function (xhr) {
        $("#cfd-spinner").hide();
        container.text(xhr.responseText);
      }
    });
  };

  var buildAndLoad = function (boardId, boardName) {
    _boardId = boardId;
    _boardName = boardName;

    load();
  };

  return {
    build: buildAndLoad
  };
}());