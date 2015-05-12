# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#repo_chart').highcharts
    title:
      text: 'Total Issues'
      x: -20
    subtitle:
      text: '(In Each Repository)'
      x: -20
    xAxis:
      categories: $('#repo_chart').data('highchartxdata')
    yAxis:
      title:
        text: 'Issues (In Each Repository)'
      min: 0
    legend:
      layout: 'vertical'
      align: 'right'
      verticalAlign: 'middle'
      borderWidth: 0
    series: [{
      name: 'Issues'
      data: $('#repo_chart').data('highchartydata')
    }]
    chart:
      backgroundColor: 'rgba(0,0,0,0)'
      plotBorderWidth: 1
      plotBorderColor: '#666'
      borderWidth: 3
      borderColor: '#666'