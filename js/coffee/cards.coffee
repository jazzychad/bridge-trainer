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

class WarEngine
  constructor: ->
    @table = new CardTable(2)
    @player0 = @table.players[0]
    @player1 = @table.players[1]

    @table.deck.shuffle()
    @table.dealHand 26

  go: ->
    player0 = @player0
    player1 = @player1
    done = false
    winner = -1
    round = 0
    until done
      ++round
      card0 = @player0.hand.pop()
      card1 = @player1.hand.pop()
      @table.currentTrick.push card0
      @table.currentTrick.push card1

      if card0.value > card1.value
        player0.discardCards @table.currentTrick
        sys.print '0'
      else if card0.value < card1.value
        player1.discardCards @table.currentTrick
        sys.print '1'
      else
        sys.print 'WAR!'
        war_over = false
        until war_over
          if player0.hand.length < 4 and player0.discards.length > 0
            DeckUtil.shuffleCards player0.discards
            player0.hand = player0.discards.concat player0.hand
            player0.discards = []

          if player0.hand.length is 0
            if player1.hand.length + player1.discards.length is 0
              winner = -1
              war_over = true
              done = true
              continue
            else
              winner = 1
              war_over = true
              done = true
              continue
          else if player0.hand.length is 1
            card0 = player0.hand.pop()
          else if player0.hand.length is 2
            @table.currentTrick.push player0.hand.pop()
            card0 = player0.hand.pop()
          else if player0.hand.length is 3
            @table.currentTrick.push player0.hand.pop()
            @table.currentTrick.push player0.hand.pop()
            card0 = player0.hand.pop()
          else
            @table.currentTrick.push player0.hand.pop()
            @table.currentTrick.push player0.hand.pop()
            @table.currentTrick.push player0.hand.pop()
            card0 = player0.hand.pop()

          if player1.hand.length < 4 and player1.discards.length > 0
            DeckUtil.shuffleCards player1.discards
            player1.hand = player1.discards.concat player1.hand
            player1.discards = []

          if player1.hand.length is 0
            if player0.hand.length + player0.discards.length is 0
              winner = -1
              done = true
              war_over = true
              continue
            else
              winner = 0
              done = true
              war_over = true
              continue
          else if player1.hand.length is 1
            card1 = player1.hand.pop()
          else if player1.hand.length is 2
            @table.currentTrick.push player1.hand.pop()
            card1 = player1.hand.pop()
          else if player1.hand.length is 3
            @table.currentTrick.push player1.hand.pop()
            @table.currentTrick.push player1.hand.pop()
            card1 = player1.hand.pop()
          else
            @table.currentTrick.push player1.hand.pop()
            @table.currentTrick.push player1.hand.pop()
            @table.currentTrick.push player1.hand.pop()
            card1 = player1.hand.pop()

          @table.currentTrick.push card0
          @table.currentTrick.push card1

          if card0.value > card1.value
            player0.discardCards @table.currentTrick
            war_over = true
            sys.print '0(' + @table.currentTrick.length + ')'
          else if card0.value < card1.value
            player1.discardCards @table.currentTrick
            war_over = true
            sys.print '1(' + @table.currentTrick.length + ')'
          else
            sys.print 'WAR AGAIN!'

      @table.currentTrick = []

      if done then break

      # check for empty hands and winning conditions
      if player0.hand.length is 0
        if player0.discards.length is 0
          winner = 1
          done = true
        else
          DeckUtil.shuffleCards player0.discards
          player0.hand = player0.discards
          player0.discards = []

      if player1.hand.length is 0
        if player1.discards.length is 0
          winner = 0
          done = true
        else
          DeckUtil.shuffleCards player1.discards
          player1.hand = player1.discards
          player1.discards = []

      if true
        sys.print '.'
        #sys.puts "0 hand: " + player0.hand.length
        #sys.puts "0 disc: " + player0.discards.length
        #sys.puts "1 hand: " + player1.hand.length
        #sys.puts "1 disc: " + player1.discards.length

    sys.puts ' '
    sys.puts 'done. rounds: ' + round + ' winner: ' + winner

# table = new CardTable 4
# table.deck.shuffle()
# DeckUtil.printDeckShort table.deck
#
# table.dealHand 5
#
# for player in table.players
#   sys.puts 'player...'
#   DeckUtil.printHandShort player.hand
#
# sys.puts 'out'
# DeckUtil.printCardsShort table.deck.out

war = new WarEngine()

war.go()