# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$('#issue_chart').highcharts
#  title:
#    text: 'Total Issues'
#    x: -20
#  subtitle:
#    text: '(In Each Repository)'
#    x: -20
#  xAxis:
#    categories: $('#issue_chart').data('issuexdata')
#  yAxis:
#    title:
#      text: 'Issues (In Each Repository)'
#    min: 0
#    allowDecimals: false
#  legend:
#    layout: 'vertical'
#    align: 'right'
#    verticalAlign: 'middle'
#    borderWidth: 0
#  credits:
#    enabled: false
#  series: [{
#    name: 'Issues'
#    data: $('#issue_chart').data('issueydata')
#  }]
#  chart:
#    backgroundColor: 'rgba(0,0,0,0)'
#    plotBorderWidth: 1
#    plotBorderColor: '#666'
#    borderWidth: 3
#    borderColor: '#666'
#  exportChart:
#    type: 'application/pdf'
#    filename: 'Total Issues'

jQuery ->
  $('#issue_chart').highcharts
    chart:
      type: 'bar'
      backgroundColor: 'rgba(0,0,0,0)'
      plotBorderWidth: 1
      plotBorderColor: '#666'
      borderWidth: 3
      borderColor: '#666'
    title:
      text: 'Repositories Having Issues'
    subtitle:
      text: '(Total Number of Issues)'
    xAxis:
      categories: $('#issue_chart').data('issuexdata')
      title:
        text: null
      allowDecimals: false
    yAxis:
      allowDecimals: false
      min: 0
      title:
        text: 'Number of Issues'
      labels:
        overflow: 'justify'
    plotOptions:
      bar:
        dataLabels:
          enabled: true
    legend:
      layout: 'vertical'
      align: 'right'
      verticalAlign: 'top'
      x: -40
      y: 100
      floating: true
      borderWidth: 1
      backgroundColor: 'rgba(0,0,0,0)'
      shadow: true
    credits:
      enabled: false
    series: [
      {
        name: 'Total Issues'
        data: $('#issue_chart').data('issueydata')
      }
    ]
    exportChart:
      type: 'application/pdf'
      filename: 'Total Issues'

  $('#contrib_chart').highcharts
    chart:
      type: 'bar'
      backgroundColor: 'rgba(0,0,0,0)'
      plotBorderWidth: 1
      plotBorderColor: '#666'
      borderWidth: 3
      borderColor: '#666'
    title:
      text: 'Total Commits By User'
    subtitle:
      text: '(Atleast 3 Total Commit or 1 Recent Commit)'
    xAxis:
      categories: $('#contrib_chart').data('contribydata')
      title:
        text: null
      allowDecimals: false
    yAxis:
      allowDecimals: false
      min: 0
      title:
        text: 'Number of Commits'
      labels:
        overflow: 'justify'
    plotOptions:
      bar:
        dataLabels:
          enabled: true
    legend:
      layout: 'vertical'
      align: 'right'
      verticalAlign: 'top'
      x: -40
      y: 100
      floating: true
      borderWidth: 1
      backgroundColor: 'rgba(0,0,0,0)'
      shadow: true
    credits:
      enabled: false
    series: [
      {
        name: 'Total Commits'
        data: $('#contrib_chart').data('contribtotalxdata')
      }
      {
        name: 'Recent Commits'
        data: $('#contrib_chart').data('contribrecentxdata')
      }
    ]
    exportChart:
      type: 'application/pdf'
      filename: 'Total Issues'

  Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, (color) ->
    {
    radialGradient:
      cx: 0.5
      cy: 0.3
      r: 0.7
    stops: [
      [
        0
        color
      ]
      [
        1
        Highcharts.Color(color).brighten(-0.3).get('rgb')
      ]
    ]
    }
  )

  $('#label_chart').highcharts
    chart:
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
      backgroundColor: 'rgba(0,0,0,0)'
      plotBorderWidth: 1
      plotBorderColor: '#666'
      borderWidth: 3
      borderColor: '#666'
    title:
      text: 'Label Association'
    credits:
      enabled: false
    plotOptions:
      pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          style:
            color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
          connectorColor: 'silver'
    series: [{
      type: 'pie'
      name: 'Label Association'
      data: $('#label_chart').data('labeldata')
    }]
    exportChart:
      type: 'application/pdf'
      filename: 'Total Issues'