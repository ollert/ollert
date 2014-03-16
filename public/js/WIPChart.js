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
            $('#cfd-spinner').hide();
            var theData = jQuery.parseJSON(data);
            var wip_data = new wipChartData();
            wip_data.lists = theData.wipcategories;
            wip_data.counts = [{name: "Cards in List", showInLegend: false, data: theData.wipdata}];
            var wc = new wipChart(wip_data);
            wc.buildChart();
            var cfdData = new cfdChartData();
            var cc = new cfdChart({ data: cfdData, boardName: "Ollert" });
            cc.buildChart();
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
            $('#board_members_count').text(theData.board_members_count);
            $('#card_count').text(theData.card_count);
            
        })
    },

    loadLabelCount: function(options){
        var jqxhr = $.get( "/boards/" + options.boardId + "/labelcounts", function(data) {
            $('#label-count-spinner').hide();
            
            var theData = jQuery.parseJSON(data);

            var lb_data = new labelCountChartData();
            lb_data.labels = theData.labels;
            lb_data.counts = theData.counts;
            var labelCount = new labelCountChart(lb_data);
            labelCount.buildChart();
        })
    }
}
