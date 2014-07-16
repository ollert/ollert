var LabelCountChartBuilder = (function () {
  var buildChart = function (options) {
    var green = '#34b27d',
      yellow = '#dbdb57',
      orange = '#e09952',
      red = '#cb4d4d',
      purple = '#93c',
      blue = '#4d77cb';

    $('#labelCountContainer').highcharts({
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

  var load = function (boardId) {
    var container = $("#labelCountContainer");
    container.height(container.height() - 10);

    $.ajax({
      url: "/boards/" + boardId + "/analysis/labelcounts",
      success: function (data) {
        $('#labelCountSpinner').hide();

        var parsed = jQuery.parseJSON(data);
        buildChart({
          labels: parsed.labels,
          counts: parsed.counts,
          colors: parsed.colors
        });
      },
      error: function (xhr) {
        $("#labelCountSpinner").hide();
        container.text(xhr.responseText);
      }
    });
  }

  return {
    build: load
  }
}());