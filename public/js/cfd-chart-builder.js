var CfdChartBuilder = (function () {
  var buildCFDChart = function (data) {
    $('#cfd-container').highcharts("StockChart", {
      chart: {
        type: 'area',
        zoomType: 'x'
      },
      rangeSelector: {
        buttons: [{
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
        selected: 2
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

  var loadCFDChart = function (parsedData) {
    $('#cfd-spinner').hide();

    var container = $("#cfd-container");
    container.height(container.height() - 10);

    buildCFDChart(parsedData);
  }

  return {
    build: loadCFDChart
  };
}());
