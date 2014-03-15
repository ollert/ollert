 var wipChart = {
    
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
var categories = wipChart.getCategories();
var data = wipChart.getData();
$(function () {
        $('#WIP-Container').highcharts({
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Work In Progress'
            },
            subtitle: {
                text: 'WIP'
            },
            xAxis: {
                categories: categories,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Cards',
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                valueSuffix: ' Cards'
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -40,
                y: 100,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: data
        });
      });
