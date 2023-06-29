//
//  Deck.swift
//  MemoryUIKit
//
//  Created by Nebojsa Pavlovic on 29.6.23..
//

import Foundation

enum Suit: CustomStringConvertible, CaseIterable {
  case spades, hearts, diamonds, clubs
  
  var description: String {
    switch self {
    case .spades:
      return "spades"
    case .hearts:
      return "hearts"
    case .diamonds:
      return "diamonds"
    case .clubs:
      return "clubs"
    }
  }
}

enum Rank: Int, CustomStringConvertible, CaseIterable {
  case ace = 1
  case two, three, four, five, six, seven, eight, nine, ten
  case jack, queen, king
  var description: String {
    switch self {
    case .ace:
      return "ace"
    case .jack:
      return "jack"
    case .queen:
      return "queen"
    case .king:
      return "king"
    default:
      return String(self.rawValue)
    }
  }
}

struct Card: CustomStringConvertible, Equatable {
  
  fileprivate let rank: Rank
  fileprivate let suit: Suit
  
  var description: String {
    return "\(rank.description)_of_\(suit.description)"
  }
}

func ==(card1: Card, card2: Card) -> Bool {
  return card1.rank == card2.rank && card1.suit == card2.suit
}

struct Deck {
  
  fileprivate var cards = [Card]()
  
//  static func full() -> Deck {
//    var deck = Deck()
//    for i in Rank.ace.rawValue...Rank.king.rawValue {
//      for suit in [Suit.spades, .hearts, .clubs, .diamonds] {
//        let card = Card(rank: Rank(rawValue: i)!, suit: suit)
//        deck.append(card)
//      }
//    }
//    return deck
//  }
  
  static func full() -> Deck {
    var deck = Deck()
    for rank in Rank.allCases {
      for suit in Suit.allCases {
        let card = Card(rank: rank, suit: suit)
        deck.append(card)
      }
    }
    return deck
  }
  
  func deckOfNumberOfCards(_ num: Int) -> Deck {
    return Deck(cards: Array(cards[0..<num]))
  }
  
  // Fisher-Yates (fast and uniform) shuffle
//  func shuffled() -> Deck {
//    var list = cards
//    for i in 0..<(list.count - 1) {
//      let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
//      if i != j {
//        list.swapAt(i, j)
//      }
//    }
//    return Deck(cards: list)
//  }
  
  func FYShuffle() -> Deck {
    var list = cards
      for i in 0..<list.count {
          let randomIndex = Int.random(in: i..<list.count)
          if i != randomIndex {
              list.swapAt(i, randomIndex)
          }
      }
    return Deck(cards: list)
  }
}

extension Deck {
  
  fileprivate mutating func append(_ card: Card) {
    cards.append(card)
  }
  
  subscript(index: Int) -> Card {
    get { return cards[index] }
  }
  
  var count: Int {
    get { return cards.count }
  }
}

func +(deck1: Deck, deck2: Deck) -> Deck {

  return Deck(cards: deck1.cards + deck2.cards)
}
