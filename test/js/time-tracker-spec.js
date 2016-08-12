'use strict';

describe('TimeTracker', function() {
  var lists, times,
      startOfWork, endOfWork,
      setupLists, addTimeFor, setTimesFor;

  beforeEach(function() {
    lists = [], times = [];

    Object.defineProperties(this, {
      tracker: {
        get: _.memoize(function() {
          return new Ollert.TimeTracker({lists: lists, times: times});
        })
      },
      subject: { get: function() { return this.tracker; }, configurable: true }
    });
  });

  describe('activeCards', function() {
    beforeEach(function() {
      setupLists('backlog', 'dev', 'qa', 'passed');
    });

    it('is empty if no actions', function() {
      expect(this.subject.activeCards()).toEqual([]);
    });

    it('does not consider start / end to be "in flight"', function() {
      addTimeFor('not started', 'backlog', {total_days: 5, business_days: 3});

      setTimesFor('in flight', {
        backlog: { total_days: 3, business_days: 3 },
        dev: { total_days: 2, business_days: 2 },
        qa: { total_days: 2, business_days: 2 }
      });

      setTimesFor('totally done', {
        backlog: { total_days: 3, business_days: 3 },
        dev: { total_days: 2, business_days: 2 },
        done: { total_days: 2, business_days: 2 }
      });

      expect(this.subject.activeCards().length).toEqual(1);
    });

    describe('data', function() {
      beforeEach(function() {
        setTimesFor('card in dev', {
          dev: { total_days: 2, business_days: 2 },
        });

        setTimesFor('card in qa', {
          backlog: { total_days: 3, business_days: 3 },
          dev: { total_days: 4, business_days: 2 },
          qa: { total_days: 2, business_days: 1 }
        });

        var findActive = function(name) {
          return _(this.subject).find(function(time) {
            return time.card.name == name;
          });
        };

        Object.defineProperties(this, {
          subject: { get: _.memoize(this.tracker.activeCards) },
          inDev: { get: _.partial(findActive, 'card in dev') },
          inQA: { get: _.partial(findActive, 'card in qa') },
        });
      });

      it('is cool when cards originated as active', function() {
        expect(this.inDev).toEqual(jasmine.objectContaining({
          active: { total_days: 2, business_days: 2 }
        }));
      });

      it('can calculate multiple active lane times', function() {
        expect(this.inQA).toEqual(jasmine.objectContaining({
          active: { total_days: 6, business_days: 3 }
        }));
      });

      describe('activeTimes', function() {
        it('knows the breakdown of time by active list', function() {
          expect(this.inQA.activeTimes).toEqual(jasmine.objectContaining({
            dev: { total_days: 4, business_days: 2 },
            qa: { total_days: 2, business_days: 1 }
          }));
        });
      });
    });
  });

  describe('average', function() {

    beforeEach(function() {
      setupLists('backlog', 'dev', 'qa', 'passed');
    });

    it('is empty if no actions', function() {
      var emptyReport = {lists: [], business_days: [], total_days: []};
      expect(this.subject.average()).toEqual(emptyReport);
    });

    it('can average a single record', function() {
      addTimeFor('card one', 'backlog', {total_days: 0, business_days: 0});

      var single = {
        lists: ['backlog'],
        total_days: [0],
        business_days: [0]
      };

      expect(this.subject.average()).toEqual(single);
    });

    it('can average more than one record', function() {
      addTimeFor('card one', 'backlog', {total_days: 4, business_days: 2});
      addTimeFor('card two', 'backlog', {total_days: 2, business_days: 4});

      var two = {
        lists: ['backlog'],
        total_days: [6 / 2],
        business_days: [6 / 2],
      };

      expect(this.subject.average()).toEqual(two);
    });

    it('supports multiple lists', function() {
      addTimeFor('card one', 'backlog', {total_days: 2, business_days: 2});
      addTimeFor('card one', 'dev', {total_days: 1, business_days: 1});

      var expected = {
        lists: ['backlog', 'dev'],
        total_days: [2, 1],
        business_days: [2, 1],
      };

      expect(this.subject.average()).toEqual(expected);
    });

    it('ignores lists that no longer exist', function() {
      addTimeFor('card one', 'backlog', {total_days: 1, business_days: 1});
      addTimeFor('card one', 'not-there-anymore', {total_days: 1, business_days: 1});

      var expected = {
        lists: ['backlog'],
        total_days: [1],
        business_days: [1]
      };

      expect(this.subject.average()).toEqual(expected);
    });

    it('reorders the result based on the original order of the lists', function() {
      setupLists('passed', 'qa', 'dev', 'backlog')

      addTimeFor('1', 'passed', {total_days: 4, business_days: 5});
      addTimeFor('2', 'qa', {total_days: 3, business_days: 6});
      addTimeFor('3', 'dev', {total_days: 2, business_days: 7});
      addTimeFor('4', 'backlog', {total_days: 1, business_days: 8});

      lists.reverse(); // reverse the expected order

      var expected = {
        lists: ['backlog', 'dev', 'qa', 'passed'],
        total_days: [1, 2, 3, 4],
        business_days: [8, 7, 6, 5]
      };

      expect(this.subject.average()).toEqual(expected);
    });

    describe('start / end of work', function() {
      var setup, 
          theAverage = function() {
            return new Ollert.TimeTracker({lists: lists, times: times}, startOfWork, endOfWork)
              .average();
          };

      beforeEach(function() {
        var lists = ['next release', 'backlog', 'dev', 'passed'],
            card = 0;

        setup = setupLists.apply(null, lists);

        _.each(lists, function(list) {
          addTimeFor((++card).toString(), list, {total_days: 1, business_days: 1});
        });
      });

      it('honors the starting list', function() {
        setup.withStart('backlog');

        var expected = {
          lists: ['backlog', 'dev', 'passed'],
          total_days: [1, 1, 1],
          business_days: [1, 1, 1]
        };

        expect(theAverage()).toEqual(expected);
      });

      it('honors the ending list as well by not including it', function() {
        setup.withStart('backlog').withEnd('passed');

        var expected = {
          lists: ['backlog', 'dev'],
          total_days: [1, 1],
          business_days: [1, 1]
        };

        expect(theAverage()).toEqual(expected);
      });

      it('ignores if the either are missing', function() {
        setup.withStart('notThere').withEnd('alsoNotThere');

        var expected = {
          lists: ['next release', 'backlog', 'dev', 'passed'],
          total_days: [1, 1, 1, 1],
          business_days: [1, 1, 1, 1]
        };

        expect(theAverage()).toEqual(expected);
      });
    });

  });

  setupLists = function() {
    startOfWork = endOfWork = undefined;
    lists.splice(0, lists.length);

    _.each(arguments, function(list) {
      lists.push({id: btoa(list), name: list});
    });

    var idFor = function(name) {
      var found = _.findWhere(lists, {name: name}) || {}
      return found.id || btoa(name);
    };

    return {
      withStart: function(startList) {
        startOfWork = idFor(startList);
        return this;
      },
      withEnd: function(endList) {
        endOfWork = idFor(endList);
        return this;
      }
    }
  };

  setTimesFor = function(card, times) {
    _(times).each(function(listTime, list) {
      addTimeFor(card, list, listTime);
    });
  };

  addTimeFor = function(card, list, listTime) {
    var cardData = _.find(times, function(t) { return t.card.id === btoa(card); });

    if(_.isUndefined(cardData)) {
      var card = { id: btoa(card), name: card, list_id: btoa(list) };
      times.push(cardData = {card: card, times: {}});
    }

    cardData.times[btoa(list)] = listTime;
    cardData.card.list_id = btoa(list);
  };
});

