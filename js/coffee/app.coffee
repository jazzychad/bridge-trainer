table = null
hand = null
biddingStrategy = new BasicBiddingStrategy()
$ = @$
bb = new @BankersBox(1)
tappable = @tappable

_log = (msg) ->
  if @console && @console.log
    @console.log(msg)

doit = ->
  _log('doit')
  hcp = 0
  table = new CardTable()
  table.deck.shuffle()
  table.dealHand 13
  hand = table.south.hand
  hcp = hand.hcp()
  @table = table
  doit() if (!DeckUtil.canOpenBidding hand, biddingStrategy)
  $("#hand").html(DeckUtil.printBridgeHand(hand))

$(document).ready ->
  doit()
  tappable "#skip", -> doit()
  tappable ".bid-btn", (e, target) ->
    openingBids = biddingStrategy.openingBidStrategy.openingBid(hand)
    bid = $(target).attr('data-bid')
    if bid in (openingBids.map (v) -> return v.bid)
      _log 'correct'
      $("#alert").addClass('alert-success').text('Correct')
      updateStats true
      doit()
    else
      _log 'incorrect'
      $("#alert").removeClass('alert-success').text('Wrong')
      updateStats false
    _log 'tap ' + $(target).attr('data-bid')
    displayStats()

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

displayStats = ->
  $("#alert").text('(' + bb.get('correct_attempts') + '/' + bb.get('total_attempts') + ') | (' + bb.get('last50_correct') + '/' + bb.lrange('last50_attempts', 0, -1).length + ')')

@window.addEventListener("load", ->
  setTimeout(( ->
    @window.scrollTo 0, 1),
    0))

@doit = doit