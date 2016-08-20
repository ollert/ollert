var ListChangesChartBuilder = (function() {
  var buildTimeInLists = function(options) {
        $('#time-in-lists-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'Time Spent in Lists'
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
              text: 'Days'
            },
            labels: {
              overflow: 'justify'
            }
          },
          legend: {
            enabled: true
          },
          tooltip: {
            pointFormat: 'Average {series.name}: <strong>{point.y:,.2f}</strong>',
            format: '{point.y:,.2f}'
          },
          plotOptions: {
            bar: {
              dataLabels: {
                enabled: true,
                format: '{point.y:,.2f}'
              }
            }
          },
          credits: {
            enabled: false
          },
          series: options.data
        });
      },
      buildActive = function(activeCards) {
        var firstCard = activeCards[0] || [],
            series = _(firstCard.activeTimes).chain().keys()
              .map(function(list) {
                return { name: list, data: [] };
              }).value(),
            seriesById = _(series).indexBy('name'),
            cardNames = _(activeCards).map(function(active) {
              return active.card.name;
            }),
            options = {
              categories: cardNames,
              data: series
            };

        _(activeCards).each(function(active) {
          _(active.activeTimes).each(function(time, list) {
            seriesById[list].data.push(time.business_days);
          });
        });

        $('#active-cards-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'Active Cards'
          },
          xAxis: {
            categories: options.categories,
            labels: {
              formatter: function() {
                return this.value.slice(0, 50) + '...';
              }
            }
          },
          yAxis: {
            min: 0,
            stackLabels: {
              enabled: true,
              style: {
                fontWeight: 'bold',
                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
              }
            }
          },
          legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
          },
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
          },
          plotOptions: {
            column: {
              stacking: 'normal',
              dataLabels: {
                enabled: true,
                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                style: {
                  textShadow: '0 0 3px black'
                }
              }
            },
            series: {
              dataLabels: {
                formatter: function() {
                  if(this.y !== 0) {
                    return this.y;
                  }
                }
              }
            }
          },
          credits: {
            enabled: false
          },
          series: options.data
        });
      },
      load = function(boardId, token, startOfWork, endOfWork) {
        var container = $('#time-in-lists-container').add('#active-cards-container');
        container.height(container.height() - 10);

        $.ajax({
          url: "/api/v1/listchanges/" + boardId,
          data: {
            token: token
          },
          success: function(data) {
            $('.list-changes-spinner').hide();

            var tracker = new Ollert.TimeTracker(jQuery.parseJSON(data), startOfWork, endOfWork),
                averages = tracker.average(),
                active = tracker.activeCards();

            buildTimeInLists({
              categories: averages.lists,
              data: [
                {
                  name: "Total Days",
                  data: averages.total_days
                },
                {
                  name: "Business Days",
                data: averages.business_days
                }
              ]
            });

            buildActive(active);
          },
          error: function(xhr) {
            $(".list-changes-spinner").hide();
            container.text(xhr.responseText);
          }
        });
      };

  return {
    build: load
  };
}());
