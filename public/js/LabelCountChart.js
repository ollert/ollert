function labelCountChartData() {
    this.labels = [];
    this.counts = [];
}

function labelCountChart(label_count_data) {
    this.categories = label_count_data.labels;
    this.data = label_count_data.counts;
    
    this.buildChart = function() {
        var that = this;
            $('#LabelCount-Container').highcharts({
                chart: {
                    type: 'bar'
                },
                title: {
                    text: 'Card count per label'
                },
                subtitle: {
                    text: 'cards can have multiple labels'
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
                credits: {
                    enabled: false
                },
                series: that.data
            });
          };
 }
