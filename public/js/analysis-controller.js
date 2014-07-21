var AnalysisController = function (boardId, boardName) {
  var _boardId = boardId;
  var _boardName = boardName;

  var loadCharts = function (options) {
    WipChartBuilder.build(_boardId);
    LabelCountChartBuilder.build(_boardId);
    CfdChartBuilder.build(_boardId, _boardName, options);
    StatsBuilder.build(_boardId, options);
  }

  return {
    init: loadCharts,
    reload: loadCharts
  }
};

$(document).ready(function () {
  var datePickerOptions = {
    ranges: {
      'Today': [moment(), moment()],
      'Last 7 Days': [moment().subtract('days', 6), moment()],
      'Last 14 Days': [moment().subtract('days', 13), moment()]
    },
    locale: { cancelLabel: 'Clear' },
    showDropdowns: true
  };

  var datePickerApply = function(start, end, label) {
    $('.date-range span.default').hide();
    $('.date-range span.range').show();
    $('.date-range span.range span.from').html(start.format('MM/DD/YYYY'))
    $('.date-range span.range span.to').html(end.format('MM/DD/YYYY'));

    analysisController.reload({date_from: start, date_to: end});
  };

  $('.date-range').daterangepicker(datePickerOptions, datePickerApply);
  $('.date-range').on('cancel.daterangepicker', function(event, picker) {
    $('.date-range span.default').show();
    $('.date-range span.range').hide();

    analysisController.reload();
  });
});
