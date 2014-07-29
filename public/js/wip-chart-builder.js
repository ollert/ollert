var WipChartBuilder = (function () {
  var buildChart = function (options) {
    $('#wipContainer').highcharts({
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
        categories: options.categories,
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
        pointFormat: 'Cards in list: <strong>{point.y} Cards</strong>',
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
      series: options.data
    });
  }

  var load = function (boardId) {
    var container = $("#wipContainer")
    container.height(container.height() - 10);

    $.ajax({
      url: "/boards/" + boardId + "/analysis/wip",
      success: function (data) {
        $('#wipSpinner').hide();

        var parsed = jQuery.parseJSON(data);
        buildChart({
          categories: parsed.wipcategories,
          data: [{
            name: "Cards in List",
            showInLegend: false,
            data: parsed.wipdata
          }]
        });
      },
      error: function (xhr) {
        $("#wipSpinner").hide();
        container.text(xhr.responseText);
      }
    });
  }

  return {
    build: load
  }
}());
