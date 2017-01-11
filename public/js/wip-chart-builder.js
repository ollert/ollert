var WipChartBuilder = (function() {
  var buildChart = function(options) {
    $('#wip-container').highcharts({
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

  var load = function(boardId, token, showArchived) {
    var container = $("#wip-container")
    container.height(container.height() - 10);

    $.ajax({
      url: "/api/v1/wip/" + boardId,
      data: {
        token: token
      },
      success: function(data) {
        $('#wip-spinner').hide();

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
      error: function(xhr) {
        $("#wip-spinner").hide();
        container.text(xhr.responseText);
      }
    });
  }

  return {
    build: load
  }
}());
