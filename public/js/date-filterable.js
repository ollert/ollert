var DateFilterable = (function () {
  var getQueryString = function(parameters) {
    var queryString = '';
    if (parameters) {
      for (var property in parameters) {
        if (parameters.hasOwnProperty(property)) {
          queryString += queryString === '' ? '?' : '&';

          queryString += encodeURI(property);
          queryString += '=';
          queryString += encodeURI(parameters[property].format('YYYY-MM-DD'));
        }
      }
    }

    return queryString;
  };

  return {
    getQueryString: getQueryString
  };
})();
