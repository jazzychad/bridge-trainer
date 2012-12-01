// Generated by CoffeeScript 1.4.0
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Array.prototype.remove = function(e) {
    var t, _ref;
    if ((t = this.indexOf(e)) > -1) {
      return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
    }
    return true;
  };

  this.Card = (function() {
    var hcps, ranks, ranksShort, suits, suitsShort, values;

    suits = ["Spades", "Hearts", "Diamonds", "Clubs"];

    suitsShort = ["S", "H", "D", "C"];

    ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"].reverse();

    ranksShort = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].reverse();

    values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14].reverse();

    hcps = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4].reverse();

    function Card(id) {
      this.id = id;
      this.suit = suits[Math.floor(id / 13)];
      this.suitShort = suitsShort[Math.floor(id / 13)];
      this.rank = ranks[id % 13];
      this.rankShort = ranksShort[id % 13];
      this.value = values[id % 13];
      this.hcp = hcps[id % 13];
    }

    Card.prototype.cardName = function() {
      return "" + this.rank + " of " + this.suit;
    };

    Card.prototype.cardNameShort = function() {
      return "" + this.rankShort + this.suitShort;
    };

    Card.prototype.printName = function() {
      return this.cardName();
    };

    Card.prototype.printNameShort = function() {
      return this.cardNameShort();
    };

    Card.prototype.toString = function() {
      return "c" + this.cardNameShort();
    };

    return Card;

  })();

  this.DeckUtil = (function() {

    function DeckUtil() {}

    DeckUtil.printCards = function(cards) {
      var card, _i, _len;
      for (_i = 0, _len = cards.length; _i < _len; _i++) {
        card = cards[_i];
        card.printName();
      }
      return true;
    };

    DeckUtil.printCardsShort = function(cards) {
      var card, _i, _len;
      for (_i = 0, _len = cards.length; _i < _len; _i++) {
        card = cards[_i];
        card.printNameShort();
      }
      return true;
    };

    DeckUtil.printDeck = function(deck) {
      return this.printCards(deck.cards);
    };

    DeckUtil.printDeckShort = function(deck) {
      return this.printCardsShort(deck.cards);
    };

    DeckUtil.printBridgeHand = function(hand, sep) {
      var ret;
      if (sep == null) {
        sep = "<br/>";
      }
      ret = "";
      if (hand.origSpades.length) {
        ret += "<span class='spades'>&spades; </span>";
        ret += hand.origSpades.slice().sort(function(c1, c2) {
          return c1.id - c2.id;
        }).map(function(c) {
          return c.rankShort;
        }).join(" ") + sep;
      }
      if (hand.origHearts.length) {
        ret += "<span class='hearts'>&hearts; </span>";
        ret += hand.origHearts.slice().sort(function(c1, c2) {
          return c1.id - c2.id;
        }).map(function(c) {
          return c.rankShort;
        }).join(" ") + sep;
      }
      if (hand.origDiamonds.length) {
        ret += "<span class='diams'>&diams; </span>";
        ret += hand.origDiamonds.slice().sort(function(c1, c2) {
          return c1.id - c2.id;
        }).map(function(c) {
          return c.rankShort;
        }).join(" ") + sep;
      }
      if (hand.origClubs.length) {
        ret += "<span class='clubs'>&clubs; </span>";
        ret += hand.origClubs.slice().sort(function(c1, c2) {
          return c1.id - c2.id;
        }).map(function(c) {
          return c.rankShort;
        }).join(" ") + sep;
      }
      return ret;
    };

    return DeckUtil;

  })();

  this.Deck = (function() {

    function Deck() {
      this.reset();
    }

    Deck.prototype.reset = function() {
      var x;
      this.cards = (function() {
        var _i, _results;
        _results = [];
        for (x = _i = 0; _i <= 51; x = ++_i) {
          _results.push(new Card(x));
        }
        return _results;
      })();
      this.out = [];
      this.discards = [];
      return null;
    };

    Deck.prototype.shuffle = function() {
      return this.shuffleDumb();
    };

    Deck.prototype.shuffleDumb = function() {
      var j, k, x, _i, _ref;
      for (x = _i = 0; _i <= 100; x = ++_i) {
        j = Math.floor(Math.random() * this.cards.length);
        k = Math.floor(Math.random() * this.cards.length);
        _ref = [this.cards[k], this.cards[j]], this.cards[j] = _ref[0], this.cards[k] = _ref[1];
      }
      return true;
    };

    Deck.prototype.drawCard = function() {
      var card;
      return card = Math.floor(Math.random() * this.cards.length);
    };

    Deck.prototype.deal = function(card) {
      this.out.push(card);
      return card;
    };

    Deck.prototype.discard = function(card) {
      this.discards.push(card);
      if (__indexOf.call(this.out, card) >= 0) {
        this.cards.remove(card);
      }
      return card;
    };

    Deck.prototype.dealTop = function() {
      var card;
      card = this.cards.shift();
      return this.deal(card);
    };

    Deck.prototype.dealBottom = function() {
      var card;
      card = this.cards.pop();
      return this.deal(card);
    };

    return Deck;

  })();

  this.Hand = (function() {

    function Hand() {
      this.cards = [];
      this.spades = [];
      this.hearts = [];
      this.diamonds = [];
      this.clubs = [];
      this.origCards = [];
      this.origSpades = [];
      this.origHearts = [];
      this.origDiamonds = [];
      this.origClubs = [];
    }

    Hand.prototype.addCard = function(card) {
      this.cards.push(card);
      this.origCards.push(card);
      if (card.suit === "Spades") {
        this.spades.push(card);
        this.origSpades.push(card);
      } else if (card.suit === "Hearts") {
        this.hearts.push(card);
        this.origHearts.push(card);
      } else if (card.suit === "Diamonds") {
        this.diamonds.push(card);
        this.origDiamonds.push(card);
      } else if (card.suit === "Clubs") {
        this.clubs.push(card);
        this.origClubs.push(card);
      }
      return true;
    };

    Hand.prototype.numCards = function() {
      return this.cards.length;
    };

    Hand.prototype.sort = function() {
      return this.cards.sort(function(c1, c2) {
        return c1.id - c2.id;
      });
    };

    Hand.prototype.hcp = function() {
      return this.cards.reduce((function(prev, cur) {
        return prev + cur.hcp;
      }), 0);
    };

    Hand.prototype.shape = function() {
      var arr;
      arr = [];
      arr.push(this.origSpades.length, this.origHearts.length, this.origDiamonds.length, this.origClubs.length);
      return arr.sort(function(a, b) {
        return b - a;
      });
    };

    Hand.prototype.shapeString = function() {
      return this.shape().join(",");
    };

    Hand.prototype.isBalanced = function() {
      if (this.shapeString() === "4,3,3,3" || this.shapeString() === "5,3,3,2" || this.shapeString() === "4,4,3,2") {
        return true;
      }
      return false;
    };

    Hand.prototype.numVoids = function() {
      return this.shape().filter(function(c) {
        return c === 0;
      }).length;
    };

    Hand.prototype.numSingletons = function() {
      return this.shape().filter(function(c) {
        return c === 1;
      }).length;
    };

    Hand.prototype.numDoubletons = function() {
      return this.shape().filter(function(c) {
        return c === 2;
      }).length;
    };

    return Hand;

  })();

  this.CardPlayer = (function() {

    function CardPlayer() {
      this.hand = new Hand;
      this.partner = null;
      this.tricks = [];
      this.discards = [];
    }

    CardPlayer.prototype.reset = function() {
      this.hand = new Hand;
      this.tricks = [];
      return this.discards = [];
    };

    CardPlayer.prototype.addCard = function(card) {
      return this.hand.addCard(card);
    };

    CardPlayer.prototype.removeCard = function(card) {
      return this.hand.remove(card);
    };

    CardPlayer.prototype.discardCards = function(cards) {
      var card, _i, _len, _results;
      if (cards instanceof Array) {
        _results = [];
        for (_i = 0, _len = cards.length; _i < _len; _i++) {
          card = cards[_i];
          _results.push(this.discards.push(card));
        }
        return _results;
      } else {
        return this.discards.push(cards);
      }
    };

    return CardPlayer;

  })();

  this.CardTable = (function() {

    function CardTable(num_players) {
      this.num_players = num_players != null ? num_players : 4;
      this.deck = new Deck();
      this.currentTrick = [];
      this.reset();
    }

    CardTable.prototype.reset = function() {
      var x;
      this.players = (function() {
        var _i, _ref, _results;
        _results = [];
        for (x = _i = 1, _ref = this.num_players; 1 <= _ref ? _i <= _ref : _i >= _ref; x = 1 <= _ref ? ++_i : --_i) {
          _results.push(new CardPlayer());
        }
        return _results;
      }).call(this);
      if (this.num_players === 4) {
        this.south = this.players[0];
        this.west = this.players[1];
        this.north = this.players[2];
        this.east = this.players[3];
      }
      return this.resetDeck();
    };

    CardTable.prototype.resetDeck = function() {
      return this.deck.reset();
    };

    CardTable.prototype.dealHand = function(num) {
      var x, _i, _ref;
      for (x = _i = 0, _ref = this.num_players * num; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        this.players[x % this.num_players].addCard(this.deck.dealTop());
      }
      return true;
    };

    return CardTable;

  })();

  this.BasicOpeningBidStrategy = (function() {

    function BasicOpeningBidStrategy() {
      this.weak2BidsEnabled = false;
      this.minimum1BidHCP = 12;
    }

    BasicOpeningBidStrategy.prototype.openingBid = function(hand) {
      var _ref;
      if (hand.hcp() < this.minimum1BidHCP) {
        if (!this.weak2BidsEnabled) {
          return "Pass";
        } else {
          return "Pass";
        }
      }
      if ((15 <= (_ref = hand.hcp()) && _ref <= 17) && hand.isBalanced()) {
        return "1NT";
      }
      if (hand.hcp() >= 22) {
        return "2C";
      }
      return "Other";
    };

    return BasicOpeningBidStrategy;

  })();

  this.BasicBiddingStrategy = (function() {

    function BasicBiddingStrategy() {
      this.jacobyTransfers = false;
      this.staymanConvention = false;
      this.openingBidStrategy = new BasicOpeningBidStrategy();
      this.respondingBidStrategy = null;
      this.openingRebidStrategy = null;
    }

    return BasicBiddingStrategy;

  })();

}).call(this);
