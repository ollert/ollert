describe('TimeSpent', function() {
  var subject,
      lists, times,
      setupLists, addTimeFor;

  beforeEach(function() {
    lists = [], times = [];

    subject = new Ollert.TimeSpent({lists: lists, times: times});
  });

  describe('average', function() {
    beforeEach(function() {
      setupLists('backlog', 'dev', 'qa', 'passed');
    });

    it('is empty if no actions', function() {
      var emptyReport = {lists: [], business_days: [], total_days: []};
      expect(subject.average()).toEqual(emptyReport);
    });

    it('can average a single record', function() {
      addTimeFor('one card', 'backlog', {total_days: 0, business_days: 0});

      var single = {
        lists: ['backlog'],
        total_days: [0],
        business_days: [0]
      };

      expect(subject.average()).toEqual(single);
    });

    it('can average more than one record', function() {
      addTimeFor('card one', 'backlog', {total_days: 4, business_days: 2});
      addTimeFor('card two', 'backlog', {total_days: 2, business_days: 4});

      var two = {
        lists: ['backlog'],
        total_days: [6 / 2],
        business_days: [6 / 2],
      };

      expect(subject.average()).toEqual(two);
    });

    it('supports multiple lists', function() {
      addTimeFor('card one', 'backlog', {total_days: 2, business_days: 2});
      addTimeFor('card one', 'dev', {total_days: 1, business_days: 1});

      var expected = {
        lists: ['backlog', 'dev'],
        total_days: [2, 1],
        business_days: [2, 1],
      };

      expect(subject.average()).toEqual(expected);
    });
  });

  setupLists = function() {
    _.each(arguments, function(list) {
      lists.push({id: btoa(list), name: list});
    });
  };

  addTimeFor = function(card, list, listTime) {
    var cardData = _.find(times, function(t) { return t.card_id === btoa(card); });
    if(_.isUndefined(cardData)) {
      times.push(cardData = {card_id: btoa(card), times: {}});
    }

    cardData.times[btoa(list)] = listTime;
  };
});
