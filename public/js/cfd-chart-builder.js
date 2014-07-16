var CfdChartBuilder = (function (options) {
  var buildChart = function (options) {
    $('#CFD-Container').highcharts({
      chart: {
        type: 'area'
      },
      title: {
        text: 'Cumulative Flow Diagram'
      },
      subtitle: {
        text: 'CFD'
      },
      xAxis: {
        categories: options.dates,
        tickmarkPlacement: 'on',
        title: {
          enabled: false
        }
      },
      yAxis: {
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
      series: options.data
    });
  }

  return {
    build: buildChart
  }
}());