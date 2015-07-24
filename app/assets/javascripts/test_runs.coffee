# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

getTree = ->
  # Some logic to retrieve, or generate tree structure
  tree = []
  run = $("#tree").data("the-tree")
  for suite in run['test_suites']
    ts = {
      text: suite.name
      tags: [suite['test_cases'].length]
      state: {
        expanded: false
      }
      nodes: []
    }
    for tc in suite['test_cases']
      ts['nodes'].push {
        text: tc.name
        data: tc
      }
    tree.push ts

  $('#tree').treeview
    data: tree,
    showTags: true
  $('#tree').on 'nodeSelected', (event, data) ->
    console.log 'node selected'
    $.ajax
      url: '/fetch_test_case'
      type: 'GET'
      data: {id: data.data.id}
      success: (response) ->
        $('#coll-buttons > .btn').on 'click', (e) ->
          e.preventDefault
          $('.coll-content').collapse('hide')

resizeView = ->
  nh = $(window).height() - $('nav').height() - $('#header').height() - $('#header').outerHeight()
  console.log nh
  $('#main-view').css('height', nh)

test_run_ready = ->
  $('#by-errors').on 'click', (event, data) ->
    $.ajax
      url: '/fetch_tree'
      type: 'GET'
      data: {id: $('#main-view').data('test-run-id'), group_by: 'errors'}
  $('#by-features').on 'click', (event, data) ->
    $.ajax
      url: '/fetch_tree'
      type: 'GET'
      data: {id: $('#main-view').data('test-run-id'), group_by: 'features'}
  $.ajax
    url: '/fetch_tree'
    type: 'GET'
    data: {id: $('#main-view').data('test-run-id')}

$(document).ready test_run_ready
$(document).on 'page:change', test_run_ready
# $(document).on 'page:change', test_run_ready
#$(document).on 'page:change', getTree

$(document).ready resizeView
$(window).resize resizeView
$(document).on 'page:change', resizeView
