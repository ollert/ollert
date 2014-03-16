var cfDXAxisRange = {
   
   getXAxisMonths: function () {
        var d = new Date();
        var month = new Array();
        month[0] = "Jan";
        month[1] = "Feb";
        month[2] = "Mar";
        month[3] = "Apr";
        month[4] = "May";
        month[5] = "Jun";
        month[6] = "Jul";
        month[7] = "Aug";
        month[8] = "Sep";
        month[9] = "Oct";
        month[10] = "Nov";
        month[11] = "Dec";
        var currentMonth = d.getUTCMonth();
        var currentYear = d.getUTCFullYear();
        var year = currentYear;
        var theMonths = new Array();
       
        for (var i = 0; i < 12; i++) {
            if (currentMonth < 0) {
                currentMonth = 11
                year = currentYear - 1
            }
            theMonths.unshift(month[currentMonth] + " " + year);
            currentMonth = currentMonth - 1;
        }
        
        return theMonths;
    }
}

cfDXAxisRange.getXAxisMonths();

function cfdChartData() {
    
    this.categories = function(){
        return cfDXAxisRange.getXAxisMonths();
    },

    this.data = function(){
        return  [{
                name: 'Feature Ideas / Stretch Goals',
                data: [2, 2, 3, 3, 5, 5, 6, 7, 8, 9, 10, 12]
            }, {
                name: 'To Do',
                data: [2, 2, 3, 3, 5, 5, 6, 7, 8, 9, 10, 12]
            }, {
                name: 'Doing',
                data: [2, 2, 3, 3, 5, 5, 6, 7, 8, 9, 10, 12]
            }, {
                name: 'Done',
                data: [2, 2, 3, 3, 5, 5, 6, 7, 8, 9, 10, 12]
            }];
    }
};

function cfdChart(options) {
    
    this.buildChart = function() {
        $('#CFD-Container').highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: 'Cumulative Flow Diagram for ' + options.boardName
            },
            subtitle: {
                text: 'Source: Trello'
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
                labels: {
                }
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
 }