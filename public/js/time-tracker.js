(function(root) {
    'use strict';

    var average = function(field) {
            return _.property(field)(this) / this.list_count;
        },
        newRunningTotal = function() {
            return { business_days: 0, total_days: 0, list_count: 0, average: average };
        },
        orderTheAveragesBy = function(averages, thisOrder) {
            if(_.isEmpty(averages.lists)) {
                return averages;
            }

            var unordered = _.zip(averages.lists, averages.total_days, averages.business_days),
                ordered = _.map(thisOrder, function(list) {
                    var theListMatches = function(set) {
                        return _.first(set) === list;
                    };

                    return _.find(unordered, theListMatches);
                }),
                orderedWithoutMissing = _.compact(ordered);

            return _.object(['lists', 'total_days', 'business_days'], _.zip.apply(_, orderedWithoutMissing));
        },
        countTheDays = function(runningTotals, listTotals) {
            var listOrDefault = function(id) {
                    return runningTotals[id] = runningTotals[id] || newRunningTotal();
                },
                list = listOrDefault(_.first(listTotals)),
                times = _.last(listTotals);

            list.total_days += times.total_days;
            list.business_days += times.business_days;
            list.list_count++;
        },
        aggregateLists = function(actions) {
            return _.reduce(actions, function(runningTotals, current) {
                _.each(_.pairs(current), _.partial(countTheDays, runningTotals));
                return runningTotals;
            }, {});
        };

    function TimeTracker(listChanges) {
        var lists = listChanges.lists,
            cardTimes = listChanges.times,
            listName = function(id) {
                var found = _.find(lists, function(list) {
                    return list.id === id;
                });

                return found ? found.name : null;
            };

        this.average = function() {
            var listTotals = _.pairs(aggregateLists(_.pluck(cardTimes, 'times'))),
                averages;

            averages =  _.reduce(listTotals, function(result, kv) {
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

            return orderTheAveragesBy(averages, _.pluck(lists,'name'));
        };
    };

    root.TimeTracker = TimeTracker;
})(Ollert);

