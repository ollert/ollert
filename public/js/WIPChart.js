function wipChartData() {
  this.lists = [];
  this.counts = [];
};

function wipChart(wip_data) {
  this.categories = wip_data.lists;
  this.data = wip_data.counts;

  this.buildChart = function() {
    var that = this;
    $('#WIP-Container').highcharts({
      chart: {
        type: 'bar'
      },
      title: {
        text: 'Work In Progress'
      },
      subtitle: {
        text: 'WIP'
      },
      xAxis: {
        categories: that.categories,
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
          }
        }
      },
      credits: {
        enabled: false
      },
      series: that.data
    });
  };
};