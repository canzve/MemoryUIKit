//
//  ViewController.swift
//  MemoryUIKit
//
//  Created by Nebojsa Pavlovic on 29.6.23..
//

import UIKit

enum Difficulty {
  case easy, medium, hard
}

class ViewController: UIViewController {
  
  let easyButton = UIButton.makeButton(title: "EASY", color: .emerald())
  let mediumButton = UIButton.makeButton(title: "MEDIUM", color: .sunflower())
  let hardButton = UIButton.makeButton(title: "HARD", color: .alizarin())

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup(){
    
    let stackView = UIStackView.makeVStack(subviews: [easyButton, mediumButton, hardButton])
    
    easyButton.addTarget(self, action: #selector(onEasyTapped), for: .touchUpInside)
    mediumButton.addTarget(self, action: #selector(onMediumTapped), for: .touchUpInside)
    hardButton.addTarget(self, action: #selector(onHardTapped), for: .touchUpInside)
    
    view.addSubview(stackView)
    [easyButton, mediumButton, hardButton].forEach {
      $0.widthAnchor.constraint(equalToConstant: 200).isActive = true
      $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    view.addConstraints([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
  }
  
  func newGameDifficulty(_ difficulty: Difficulty) {
    let memoryVC = MemoryViewController(difficulty: difficulty)
    present(memoryVC, animated: true)
  }

  @objc func onEasyTapped(){
    newGameDifficulty(Difficulty.easy)
  }
  @objc func onMediumTapped(){
    newGameDifficulty(Difficulty.medium)
  }
  @objc func onHardTapped(){
    newGameDifficulty(Difficulty.hard)
  }
}

