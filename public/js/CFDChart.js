var cfDXAxisRange = {
   
    // var d = new Date();
    // var month = new Array();
    // month[0]="January";
    // month[1]="February";
    // month[2]="March";
    // month[3]="April";
    // month[4]="May";
    // month[5]="June";
    // month[6]="July";
    // month[7]="August";
    // month[8]="September";
    // month[9]="October";
    // month[10]="November";
    // month[11]="December";
    // var currentMonth = month[d.getMonth()];
    // var currentYear = month[d.getYear()];
    
    getXAxisMonths: function(){
        for(var i=0; i<13; i++){
            
        }        
    }

}

var cfdChart = {
    
    getCategories: function(){
        return ['Feature Ideas / Stretch Goals', 'To Do', 'Doing', 'Done'];
    },
    
    getData: function(){
        return [
                { 
                    name: "Card in List",
                    data: [1, 2, 4, 7]
                }
               ];
    }
};
var categories = cfdChart.getCategories();
var data = cfdChart.getData();

$(function () {
        $('#CFD-Container').highcharts({
            chart: {
                type: 'area'
            },
            title: {
                text: 'Historic and Estimated Worldwide Population Growth by Region'
            },
            subtitle: {
                text: 'Source: Wikipedia.org'
            },
            xAxis: {
                categories: ['1750', '1800', '1850', '1900', '1950', '1999', '2050'],
                tickmarkPlacement: 'on',
                title: {
                    enabled: false
                }
            },
            yAxis: {
                title: {
                    text: 'Billions'
                },
                labels: {
                    formatter: function() {
                        return this.value / 1000;
                    }
                }
            },
            tooltip: {
                shared: true,
                valueSuffix: ' millions'
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
            series: [{
                name: 'Asia',
                data: [502, 635, 809, 947, 1402, 3634, 5268]
            }, {
                name: 'Africa',
                data: [106, 107, 111, 133, 221, 767, 1766]
            }, {
                name: 'Europe',
                data: [163, 203, 276, 408, 547, 729, 628]
            }, {
                name: 'America',
                data: [18, 31, 54, 156, 339, 818, 1201]
            }, {
                name: 'Oceania',
                data: [2, 2, 2, 6, 13, 30, 46]
            }]
        });
    });