sys = require('util')

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class Card
  suits = ["Spades", "Diamonds", "Clubs", "Hearts"]
  suitsShort = ["S", "D", "C", "H"]
  ranks = ["Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"]
  ranksShort = ["A","2","3","4","5","6","7","8","9","T","J","Q","K"]
  values = [14,2,3,4,5,6,7,8,9,10,11,12,13]

  constructor: (@id) ->
    @suit = suits[Math.floor(id / 13)]
    @suitShort = suitsShort[Math.floor(id / 13)]
    @rank = ranks[id % 13]
    @rankShort = ranksShort[id % 13]
    @value = values[id % 13]

  cardName: ->
    "#{@rank} of #{@suit}"

  cardNameShort: ->
    "#{@rankShort}#{@suitShort}"

  printName: ->
    sys.puts @cardName()

  printNameShort: ->
    sys.puts @cardNameShort()

  toString: ->
    "c" + @cardNameShort()

class DeckUtil
  constructor: ->

  @printCards = (cards) ->
    for card in cards
      card.printName()
    true

  @printCardsShort = (cards) ->
    for card in cards
      card.printNameShort()
    true

  @printDeck = (deck) ->
    @printCards deck.cards

  @printHand = (hand) ->
    @printCards hand

  @printDeckShort = (deck) ->
    @printCardsShort deck.cards

  @printHandShort = (hand) ->
    @printCardsShort hand

  shuffleDumb = (cards) ->
    for x in [0..100]
      j = Math.floor Math.random() * cards.length
      k = Math.floor Math.random() * cards.length
      [cards[j], cards[k]] = [cards[k], cards[j]]
    cards

  @shuffleCards: (cards) ->
    shuffleDumb cards

class Deck
  constructor: ->
    @reset()

  reset: ->
    @cards = for x in [0..51]
      new Card x
    @out = []
    @discards = []
    null

  shuffle: ->
    @shuffleDumb()

  shuffleDumb: ->
    for x in [0..100]
      j = Math.floor Math.random() * @cards.length
      k = Math.floor Math.random() * @cards.length
      [@cards[j], @cards[k]] = [@cards[k], @cards[j]]
    true

  drawCard: ->
    card = Math.floor Math.random() * @cards.length
    #TODO this isn't quite right

  deal: (card) ->
    @out.push card
    card

  discard: (card) ->
    @discards.push card
    if card in @out then @cards.remove card
    card

  dealTop: ->
    card = @cards.shift()
    @deal card

  dealBottom: ->
    card = @cards.pop()
    @deal card

class CardPlayer
  constructor: ->
    @hand = []
    @partner = null
    @tricks = []
    @discards = []

  reset: ->
    @hand = []
    @tricks = []
    @discards = []

  addCard: (card) ->
    @hand.push card

  removeCard: (card) ->
    @hand.remove card

  discardCards: (cards) ->
    if cards instanceof Array
      @discards.push card for card in  cards
    else
      @discards.push cards

class CardTable
  constructor: (@num_players=4) ->
    @deck = new Deck()
    @currentTrick = []
    @reset()

  reset: ->
    @players = for x in [1..@num_players]
      new CardPlayer()
    @resetDeck

  resetDeck: ->
    @deck.reset()

  dealHand: (num) ->
    for x in [0...(@num_players * num)]
      @players[x % @num_players].addCard @deck.dealTop()
    true
