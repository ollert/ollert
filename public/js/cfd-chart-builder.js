var CfdChartBuilder = (function (options) {
  var buildChart = function (options) {
    $('#cfdContainer').highcharts({
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

  var load = function (boardId, boardName, parameters) {
    var container = $("#cfdContainer");
    container.height(container.height() - 10);

    queryString = '';
    if (typeof(parameters) != 'undefined') {
      for (var property in parameters) {
        if (parameters.hasOwnProperty(property)) {
          queryString += queryString === '' ? '?' : '&';

          queryString += encodeURI(property);
          queryString += '=';
          queryString += encodeURI(parameters[property].format('YYYY-MM-DD'));
        }
      }
    }

    $.ajax({
      url: "/boards/" + boardId + "/analysis/cfd" + queryString,
      success: function (data) {
        $('#cfdSpinner').hide();

        var parsed = jQuery.parseJSON(data);

        buildChart({
          data: parsed.cfddata,
          dates: parsed.dates,
          boardName: boardName
        });
      },
      error: function (xhr) {
        $("#cfdSpinner").hide();
        container.text(xhr.responseText);
      }
    });
  }

  return {
    build: load
  }
}());
