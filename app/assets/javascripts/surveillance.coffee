# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  Morris.Line
    element: 'repo_chart'
    data: $('#repo_chart').data('repo')
    xkey: 'name'
    ykeys: ['open_issues_count']
    labels: ['Issue Count']
    parseTime: false
    gridTextSize: 10
    xLabelAngle: 90