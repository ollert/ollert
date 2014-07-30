/**
 * @license @product.name@ JS v@product.version@ (@product.date@)
 * Plugin for displaying a message when there is no data visible in chart.
 *
 * (c) 2010-2014 Highsoft AS
 * Author: Oystein Moseng
 *
 * License: www.highcharts.com/license
 */

(function(e){function s(){return!!this.points.length}function o(){var e=this;if(e.hasData()){e.hideNoData()}else{e.showNoData()}}var t=e.seriesTypes,n=e.Chart.prototype,r=e.getOptions(),i=e.extend;i(r.lang,{noData:"No data to display"});r.noData={position:{x:0,y:0,align:"center",verticalAlign:"middle"},attr:{},style:{fontWeight:"bold",fontSize:"12px",color:"#60606a"}};if(t.pie){t.pie.prototype.hasData=s}if(t.gauge){t.gauge.prototype.hasData=s}if(t.waterfall){t.waterfall.prototype.hasData=s}e.Series.prototype.hasData=function(){return this.dataMax!==undefined&&this.dataMin!==undefined};n.showNoData=function(e){var t=this,n=t.options,r=e||n.lang.noData,s=n.noData;if(!t.noDataLabel){t.noDataLabel=t.renderer.label(r,0,0,null,null,null,null,null,"no-data").attr(s.attr).css(s.style).add();t.noDataLabel.align(i(t.noDataLabel.getBBox(),s.position),false,"plotBox")}};n.hideNoData=function(){var e=this;if(e.noDataLabel){e.noDataLabel=e.noDataLabel.destroy()}};n.hasData=function(){var e=this,t=e.series,n=t.length;while(n--){if(t[n].hasData()&&!t[n].options.isInternal){return true}}return false};n.callbacks.push(function(t){e.addEvent(t,"load",o);e.addEvent(t,"redraw",o)})})(Highcharts)
