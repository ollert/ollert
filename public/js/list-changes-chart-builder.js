var ListChangesChartBuilder = (function() {
    var buildChart = function(options) {
            $('#list-changes-container').highcharts({
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
        load = function(boardId, token) {
            var container = $("#list-changes-container");
            container.height(container.height() - 10);

            $.ajax({
                url: "/api/v1/listchanges/" + boardId,
                data: {
                    token: token
                },
                success: function(data) {
                    $('#list-changes-spinner').hide();

                    var averages = new Ollert.TimeTracker(jQuery.parseJSON(data)).average();
                    buildChart({
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
                },
                error: function(xhr) {
                    $("#list-changes-spinner").hide();
                    container.text(xhr.responseText);
                }
            });
        };

    return {
        build: load
    }
}());
