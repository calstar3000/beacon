# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	maxLength = 140
	input = $("#status_content")
	input.keyup ->
		left = maxLength - input.val().length
		$("#lblInputLeft").text(left + " character" + (if left == 1 then "" else "s") + " remaining")
