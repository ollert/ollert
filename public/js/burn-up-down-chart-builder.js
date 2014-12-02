var BurnUpDownChartBuilder = (function () {
  var build = function (data, container, title) {
    container.highcharts("StockChart", {
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
        text: title
      },
      xAxis: {
        minRange: 24 * 3600 * 1000, // one day
        tickmarkPlacement: 'on',
        title: {
          enabled: false
        },
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
      series: data
    });
  };

  var loadBurnUpChart = function (parsedData) {
    $('#burn-up-spinner').hide();

    var container = $("#burn-up-container")
    container.height(container.height() - 10);

    var burnUpSeriesData = [];
    burnUpSeriesData.push({
      name: "To Do",
      data: parsedData.cfddata[0].data
    });
    burnUpSeriesData.push({
      name: "Completed",
      data: parsedData.cfddata[1].data
    });

    build(burnUpSeriesData, container, "Burn Up");
  }

  var loadBurnDownChart = function (parsedData) {
    $('#burn-down-spinner').hide();

    var container = $("#burn-down-container")
    container.height(container.height() - 10);

    var burnDownSeriesData = [];
    burnDownSeriesData.push({
      name: "To Do",
      data: parsedData.cfddata[0].data
    });

    build(burnDownSeriesData, container, "Burn Down");
  }

  return {
    buildBurnUp: loadBurnUpChart,
    buildBurnDown: loadBurnDownChart,
  };
}());