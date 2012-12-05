table = null
hand = null

$ = @$

doit = ->
  hcp = 0
  table = new @CardTable()
  table.deck.shuffle()
  table.dealHand 13
  hand = table.south.hand
  hcp = hand.hcp()

  $("#hand").html(@DeckUtil.printBridgeHand(hand))

$(document).ready ->
  doit()
  $(".bid-btn").click ->
    doit()

@window.addEventListener("load", ->
  setTimeout(( ->
    @window.scrollTo 0, 1),
    0))