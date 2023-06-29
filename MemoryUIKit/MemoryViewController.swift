//
//  MemoryViewController.swift
//  MemoryUIKit
//
//  Created by Nebojsa Pavlovic on 29.6.23..
//

import UIKit

class MemoryViewController: UIViewController {
  
  fileprivate var collectionView: UICollectionView!
  fileprivate var deck: Deck!
  fileprivate var selectedIndexes = Array<IndexPath>()
  fileprivate var numberOfPairs = 0
  fileprivate var score = 0
  fileprivate let difficulty: Difficulty
  
  init(difficulty: Difficulty) {
    self.difficulty = difficulty
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.greenSea()
    setup()
    start()
  }
  
  fileprivate func start(){
    numberOfPairs = 0
    score = 0
    deck = createDeck(numCards: numCardsNeededDifficulty(difficulty))
    collectionView.reloadData()
  }
  
  private func createDeck(numCards: Int) -> Deck {
    let fullDeck = Deck.full().FYShuffle()
    let halfDeck = fullDeck.deckOfNumberOfCards(numCards)
    return (halfDeck + halfDeck).FYShuffle()
  }
  
  func setup() {
    let ratio: CGFloat = 1.452
    let space: CGFloat = 5
    
    let(columns, rows) = sizeDifficulty(difficulty)
    let cardHeight: CGFloat = view.frame.height/rows - 2 * space
    let cardWidth: CGFloat = cardHeight / ratio
    
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
    layout.minimumLineSpacing = space
    
    let covWidth = columns * (cardWidth + 2*space)
    let covHeight = rows * (cardHeight + space)
    collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: covWidth, height: covHeight), collectionViewLayout: layout)
    collectionView.center = view.center
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isScrollEnabled = false
    collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.backgroundColor = .clear
    
    self.view.addSubview(collectionView)
  }
  
  func sizeDifficulty(_ difficulty: Difficulty)->(CGFloat, CGFloat){
    switch difficulty {
    case .easy:     return(4,3)
    case .medium:   return(6,4)
    case .hard:     return (8,4)
    }
  }
  
  func numCardsNeededDifficulty(_ difficulty: Difficulty) -> Int {
    let(columns, rows) = sizeDifficulty(difficulty)
    return Int(columns * rows / 2)
  }
  
  func checkIfFinished(){
    if numberOfPairs == deck.count/2 {
      showFinalPopUp()
    }
  }
  
  func removeCards(){
    execAfter(delay: 1.0) {
      self.removeCardsAtPlaces(places: self.selectedIndexes)
      self.selectedIndexes = []
    }
  }
  
  func turnCardsFaceDown(){
    execAfter(delay: 2.0) {
      self.downturnCardsAtPlaces(places: self.selectedIndexes)
      self.selectedIndexes = []
    }
  }
  
  func removeCardsAtPlaces(places: Array<IndexPath>){
    for index in selectedIndexes {
      let cardCell = collectionView.cellForItem(at: index) as! CardCell
      cardCell.remove()
    }
  }
  
  func downturnCardsAtPlaces(places: Array<IndexPath>){
    for index in selectedIndexes {
      let cardCell = collectionView.cellForItem(at: index)as! CardCell
      cardCell.downturn()
    }
  }
  
  func showFinalPopUp() {
    let alert = UIAlertController(title: "Great!", message: "You won with score: \(score)!",
      preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
      self.dismiss(animated: true)
    }))
    
    self.present(alert, animated: true)
  }
}

extension MemoryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return deck.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
    let card = deck[indexPath.row]
    print("Index\(indexPath.row)")
    print("Card\(card)")
    cell.renderCardName(cardImageName: card.description, backImageName: "back")
    return cell
  }
}

extension MemoryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selectedIndexes.count == 2 || selectedIndexes.contains(indexPath) { return }
    selectedIndexes.append(indexPath)
    
    let cell = collectionView.cellForItem(at: indexPath) as! CardCell
    cell.upturn()
    
    if selectedIndexes.count < 2 {
      return
    }
    
    let card1 = deck[selectedIndexes[0].row]
    let card2 = deck[selectedIndexes[1].row]
    
    if card1 == card2 {
      numberOfPairs += 1
      checkIfFinished()
      removeCards()
    } else {
      score += 1
      turnCardsFaceDown()
    }
  }
}
