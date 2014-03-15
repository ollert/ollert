function wipChartData() {
    
    this.getCategories = function (){
        return ['Feature Ideas / Stretch Goals', 'To Do', 'Doing', 'Done'];
    };
    
    this.getData = function () {
        return [
                {
                    name: "Card in List",
                    data: [1, 2, 4, 7]
                }
               ];
    };
}

function wipChart(options) {

    this.categories = options.data.getCategories();
    this.data = options.data.getData();
    
    this.buildChart = function() {
        var that = this;
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
                    categories: that.categories,
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
                series: that.data
            });
          };
 }
