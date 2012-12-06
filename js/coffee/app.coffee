table = null
hand = null
biddingStrategy = new @BasicBiddingStrategy()
$ = @$
bb = new @BankersBox(1)
tappable = @tappable

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
  tappable ".bid-btn", (e, target) ->
    openingBids = biddingStrategy.openingBidStrategy.openingBid(hand)
    bid = $(target).attr('data-bid')
    if bid in (openingBids.map (v) -> return v.bid)
      console.log('correct')
      updateStats true
    else
      console.log('incorrect')
      updateStats false
    console.log('tap ' + $(target).attr('data-bid'))
    doit()

updateStats = (correct) ->
  bb.incr 'total_attempts'
  bb.incr 'correct_attempts' if correct
  bb.rpush 'last50_attempts', correct
  bb.ltrim 'last50_attempts', -50, -1
  last50 = bb.lrange 'last50_attempts', 0, -1
  bb.set 'last50_correct', last50.filter((v) -> v == true).length

resetStats = ->
  bb.del 'total_attempts'
  bb.del 'correct_attempts'
  bb.del 'last50_attempts'
  bb.del 'last50_correct'

@window.addEventListener("load", ->
  setTimeout(( ->
    @window.scrollTo 0, 1),
    0))