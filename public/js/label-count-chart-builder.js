var LabelCountChartBuilder = (function () {
  var buildChart = function (options) {
    var green = '#34b27d';
    var yellow = '#dbdb57';
    var orange = '#e09952';
    var red = '#cb4d4d';
    var purple = '#93c';
    var blue = '#4d77cb';
    $('#LabelCount-Container').highcharts({
      chart: {
        type: 'bar'
      },
      title: {
        text: 'Card count per label'
      },
      subtitle: {
        text: 'cards can have multiple labels'
      },
      xAxis: {
        categories: options.labels,
        title: {
          text: null
        }
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Cards',
          align: 'high'
        },
        labels: {
          overflow: 'justify'
        }
      },
      tooltip: {
        valueSuffix: ' Cards'
      },
      plotOptions: {
        bar: {
          dataLabels: {
            enabled: true
          },
          colorByPoint: true,
          colors: options.colors
        }
      },
      credits: {
        enabled: false
      },
      series: [{
        name: "Cards in List",
        showInLegend: false,
        data: options.counts
      }]
    });
  }

  return {
    build: buildChart
  }
}());