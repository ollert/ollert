var AnalysisController = (function () {
  var _boardId;
  var _boardName;

  var initialize = function (boardId, boardName) {
    _boardId = boardId;
    _boardName = boardName;

    initializeDatePicker();
    var start = moment().subtract('months', 1);
    var end = moment();
    $('.date-range').data('daterangepicker').setStartDate(start);
    $('.date-range').data('daterangepicker').setEndDate(end);
    datePickerApply(start, end);
  };

  var loadCharts = function (options) {
    WipChartBuilder.build(_boardId);
    LabelCountChartBuilder.build(_boardId);
    CfdChartBuilder.build(_boardId, _boardName, options);
    StatsBuilder.build(_boardId, options);
  };

  var getDatePickerOptions = function() {
    return {
      ranges: {
        'Today': [moment().subtract('days', 1), moment()],
        'Last 7 Days': [moment().subtract('days', 6), moment()],
        'Last 14 Days': [moment().subtract('days', 13), moment()],
        'Last Month': [moment().subtract('months', 1), moment()]
      },
      locale: { cancelLabel: 'Clear' },
      showDropdowns: true
    };
  };

  var datePickerApply = function(start, end, label) {
    $('.date-range span.default').hide();
    $('.date-range span.range').show();
    $('.date-range span.range span.from').html(start.format('MM/DD/YYYY'))
    $('.date-range span.range span.to').html(end.format('MM/DD/YYYY'));

    AnalysisController.reload({date_from: start, date_to: end});
  };

  var initializeDatePicker = function() {
    $('.date-range').daterangepicker(getDatePickerOptions(), datePickerApply);
    $('.date-range').on('cancel.daterangepicker', function(event, picker) {
      $('.date-range span.default').show();
      $('.date-range span.range').hide();
      
      AnalysisController.reload();
    });
  };

  return {
    init: initialize,
    reload: loadCharts
  }
})();
