(function(root) {
  var average = function(field) {
        return _.property(field)(this) / this.list_count;
      },
      initialAggregate = function() {
        return {
          business_days: 0, total_days: 0, list_count: 0,
          average: average
        };
      },
      aggregateLists = function(actions) {
        return _.reduce(actions, function(averages, current) {
          var listOrDefault = function(id) {
            return averages[id] = averages[id] || initialAggregate();
          };

          _.each(_.pairs(current), function(kv) {
            var list = listOrDefault(kv[0]),
            times = kv[1];

            list.total_days += times.total_days;
            list.business_days += times.business_days;
            list.list_count++;
          });

          return averages;
        }, {});
      };

  function TimeSpent(listChanges) {
    var lists = listChanges.lists,
        cardTimes = listChanges.times,
        listName = function(id) {
          var found = _.find(lists, function(list) {
            return list.id === id;
          });

          return found ? found.name : null;
        };

    this.average = function() {
      var listTotals = _.pairs(aggregateLists(_.pluck(cardTimes, 'times')));

      return _.reduce(listTotals, function(result, kv) {
        var listId = kv[0],
            listResult = kv[1],
            name = listName(listId);

        if(_.isString(name)) {
          result.lists.push(name);
          result.total_days.push(listResult.average('total_days'));
          result.business_days.push(listResult.average('business_days'));
        }

        return result;
      }, {lists: [], total_days: [], business_days: []});
    };
  }

  root.TimeSpent = TimeSpent;
})(Ollert);
