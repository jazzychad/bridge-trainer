#sys = require('util')

Array::remove = (e) ->
  return @[t..t] = [] if (t = @indexOf(e)) > -1
  true

class Card
  suits = ["Spades", "Hearts", "Diamonds", "Clubs"]
  suitsShort = ["S", "H", "D", "C"]
  ranks = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"].reverse()
  ranksShort = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"].reverse()
  values = [2,3,4,5,6,7,8,9,10,11,12,13,14].reverse()
  hcps = [0,0,0,0,0,0,0,0,0,1,2,3,4].reverse()

  constructor: (@id) ->
    @suit = suits[Math.floor(id / 13)]
    @suitShort = suitsShort[Math.floor(id / 13)]
    @rank = ranks[id % 13]
    @rankShort = ranksShort[id % 13]
    @value = values[id % 13]
    @hcp = hcps[id % 13]

  cardName: ->
    "#{@rank} of #{@suit}"

  cardNameShort: ->
    "#{@rankShort}#{@suitShort}"

  printName: ->
    @cardName() #sys.puts @cardName()

  printNameShort: ->
    @cardNameShort() #sys.puts @cardNameShort()

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

  @printDeckShort = (deck) ->
    @printCardsShort deck.cards

  @printBridgeHand = (hand, sep="<br/>") ->
    ret = ""
    if hand.origSpades.length
      ret += "<span class='spades'>&spades; </span>"
      ret += hand.origSpades.slice().sort((c1,c2) -> c1.id - c2.id).map((c) -> c.rankShort).join(" ") + sep
    if hand.origHearts.length
      ret += "<span class='hearts'>&hearts; </span>"
      ret += hand.origHearts.slice().sort((c1,c2) -> c1.id - c2.id).map((c) -> c.rankShort).join(" ") + sep
    if hand.origDiamonds.length
      ret += "<span class='diams'>&diams; </span>"
      ret += hand.origDiamonds.slice().sort((c1,c2) -> c1.id - c2.id).map((c) -> c.rankShort).join(" ") + sep
    if hand.origClubs.length
      ret += "<span class='clubs'>&clubs; </span>"
      ret += hand.origClubs.slice().sort((c1,c2) -> c1.id - c2.id).map((c) -> c.rankShort).join(" ") + sep
    ret

  @canOpenBidding = (hand, biddingStrategy) ->
    bids = biddingStrategy.openingBidStrategy.openingBid(hand)
    return true unless bids.length == 1 && bids[0].bid == "PASS"

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

class HandSuit
  constructor: (@suit) ->
    self = this
    suitShorts =
      "Spades" : "S"
      "Hearts" : "H"
      "Diamonds" : "D"
      "Clubs" : "C"
    @suitShort = suitShorts[@suit]
    @cards = []
    @length = 0

  push: ->
    @cards.push.apply(@cards, arguments)
    @length = @cards.length

  pop: ->
    card = @cards.pop.apply(@cards, arguments)
    @length = @cards.length
    card

  slice: ->
    @cards.slice.apply(@cards, arguments)

  honors: ->
    @cards.filter((v) -> v.rankShort in ["A","K","Q","J","10"])


class Hand
  constructor: ->
    @cards = []
    @spades = new HandSuit("Spades")
    @hearts = new HandSuit("Hearts")
    @diamonds = new HandSuit("Diamonds")
    @clubs = new HandSuit("Clubs")
    @handSuits = [@spades, @hearts, @diamonds, @clubs]
    @origCards = []
    @origSpades = new HandSuit("Spades")
    @origHearts = new HandSuit("Hearts")
    @origDiamonds = new HandSuit("Diamonds")
    @origClubs = new HandSuit("Clubs")
    @origHandSuits = [@origSpades, @origHearts, @origDiamonds, @origClubs]

  addCard: (card) ->
    @cards.push card
    @origCards.push card
    if card.suit == "Spades"
      @spades.push card
      @origSpades.push card
    else if card.suit == "Hearts"
      @hearts.push card
      @origHearts.push card
    else if card.suit == "Diamonds"
      @diamonds.push card
      @origDiamonds.push card
    else if card.suit == "Clubs"
      @clubs.push card
      @origClubs.push card
    true

  numCards: ->
    @cards.length

  sort: ->
    @cards.sort (c1, c2) ->
      c1.id - c2.id

  hcp: ->
    @cards.reduce ((prev, cur) ->
      prev + cur.hcp),
      0

  shape: ->
    arr = []
    arr.push @origSpades.length, @origHearts.length, @origDiamonds.length, @origClubs.length
    arr.sort (a,b) -> b-a

  shapeString: ->
    @shape().join ","

  isBalanced: ->
    return true if @shapeString() == "4,3,3,3" or @shapeString() == "5,3,3,2" or @shapeString() == "4,4,3,2"
    false

  numVoids: ->
    @shape().filter((c) -> c == 0).length

  numSingletons: ->
    @shape().filter((c) -> c == 1).length

  numDoubletons: ->
    @shape().filter((c) -> c == 2).length

#   findHonors = (arr) ->
#     arr.filter((v) -> v.rankShort in ["A","K","Q","J","10"])

#   honors: -> findHonors @origCards

#   spadeHonors: -> findHonors @origSpades

#   heartHonors: -> findHonors @origHearts

#   diamondHonors: -> findHonors @origDiamonds

#   clubHonors: -> findHonors @origClubs

class CardPlayer
  constructor: ->
    @hand = new Hand
    @partner = null
    @tricks = []
    @discards = []

  reset: ->
    @hand = new Hand
    @tricks = []
    @discards = []

  addCard: (card) ->
    @hand.addCard card

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
    if @num_players == 4
      @south = @players[0]
      @west = @players[1]
      @north = @players[2]
      @east = @players[3]
    @resetDeck()

  resetDeck: ->
    @deck.reset()

  dealHand: (num) ->
    for x in [0...(@num_players * num)]
      @players[x % @num_players].addCard @deck.dealTop()
    true


# Bidding stuff

class BasicOpeningBidStrategy
  constructor: ->
    @preemptiveBidsEnabled = false
    @minimum1BidHCP = 12

  openingBid: (hand) ->
    hcp = hand.hcp()
    if hcp < @minimum1BidHCP
      if not @preemptiveBidsEnabled
        return [new Bid("PASS")]
      else
        # TODO: handle weak bids, for now pass
        if 5 <= hcp <= 10
          for handSuit in hand.handSuits
            if handSuit.length >= 6 && handSuit.honors().length >= 2
              suitShort = handSuit.suitShort
              level = handSuit.length - 4
              bidString = "" + level + suitShort
              if bidStirng == "2C"
                return new [Bid("PASS")]
              return [new Bid(bidString)]

    if 15 <= hcp <= 17 && hand.isBalanced()
      return [new Bid("1NT")]

    if hcp == 20 && hand.isBalanced()
      return [new Bid("2NT")]

    if hcp >= 21
      return [new Bid("2C")]

    if hcp >= @minimum1BidHCP
      # check majors first
      if hand.spades.length >= 5 || hand.hearts.length >= 5
        if hand.hearts.length > hand.spades.length
          return [new Bid("1H")]
        else
          return [new Bid("1S")]
      else
        # minor suit
        if hand.clubs.length >= 3 || hand.diamonds.length >= 3
          if hand.diamonds.length > hand.clubs.length
            return [new Bid("1D")]
          else if hand.clubs.length > hand.diamonds.length
            return [new Bid("1C")]
          else
            # clubs == diamonds
            # 3 = clubs, 4+ = diamonds
            if hand.clubs.length == 3
              return [new Bid("1C")]
            else if hand.clubs.length >= 4
              return [new Bid("1D")]

    # TODO handle other 1 level bids
    [new Bid("PASS")]

class BasicBiddingStrategy
  constructor: ->
    @jacobyTransfers = false
    @staymanConvention = false
    @openingBidStrategy = new BasicOpeningBidStrategy()
    @respondingBidStrategy = null;
    @openingRebidStrategy = null;


class Bid
  constructor: (@bid) ->
