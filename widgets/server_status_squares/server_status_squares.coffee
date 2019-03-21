class Dashing.ServerStatusSquares extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    green = "#96BF48"
    red = "#BF4848"
    purple = "#800080"
    result = data && data.result
    color = ""

    if result && result.status == "OK"
      color = green
    else if result && result.status == "PARTIALLY_DEGRADED"
      color = purple
    else
      color = red

    $(@get('node')).css('background-color', "#{color}")