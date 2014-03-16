function wipChartData() {
    this.lists = [];
    this.counts = [];
};

function wipChart(wip_data) {
    this.categories = wip_data.lists;
    this.data = wip_data.counts;
    
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
                credits: {
                    enabled: false
                },
                series: that.data
            });
          };
 };
 
 var dataLoader = {
    
    loadWipChart: function(options){
        var jqxhr = $.get( "/boards/" + options.boardId + "/data", function(data) {
            $('#wip-spinner').hide();
            var theData = jQuery.parseJSON(data);
            var wip_data = new wipChartData();
            wip_data.lists = theData.wipcategories;
            wip_data.counts = [{name: "Cards in List", showInLegend: false, data: theData.wipdata}];
            var wc = new wipChart(wip_data);
            wc.buildChart();
        })
    },
    
    loadStats: function(options){
        var jqxhr = $.get( "/boards/" + options.boardId + "/stats", function(data) {
            $.each($('.stats-spinner'), function(i, item){$(item).hide();});
        
            var theData = jQuery.parseJSON(data);
            $('#avg_members_per_card').text(theData.avg_members_per_card);
            $('#avg_cards_per_member').text(theData.avg_cards_per_member);
            $('#list_with_most_cards_name').text(theData.list_with_most_cards_name);
            $('#list_with_most_cards_count').text(theData.list_with_most_cards_count);
            $('#list_with_least_cards_name').text(theData.list_with_least_cards_name);
            $('#list_with_least_cards_count').text(theData.list_with_least_cards_count);
            $('#oldest_card_name').text(theData.oldest_card_name);
            $('#oldest_card_age').text(theData.oldest_card_age);
        })

    },

    loadCfdChart: function(options){
        var jqxhr = $.get( "/boards/" + options.boardId + "/cfd", function(data) {
            $('#cfd-spinner').hide();
  
            var theData = jQuery.parseJSON(data);
            var cfdData = new cfdChartData();
            var cc = new cfdChart({ data: theData.cfddata, dates:theData.dates, boardName: "Ollert" });
            cc.buildChart();
        })
    }
}
