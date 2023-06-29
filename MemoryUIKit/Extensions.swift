//
//  Extensions.swift
//  MemoryUIKit
//
//  Created by Nebojsa Pavlovic on 29.6.23..
//

import UIKit

extension UIStackView {
  static func makeVStack(subviews: [UIView])->UIStackView {
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 30
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }
}

extension UIButton {
  static func makeButton(title: String, color: UIColor)->UIButton{
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.backgroundColor = color
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
}

extension UIColor {
  class func greenSea() -> UIColor {
    return UIColor.colorComponents((22, 160, 133))
  }
  
  class func emerald() -> UIColor {
    return UIColor.colorComponents((46, 204, 113))
  }
  
  class func sunflower() -> UIColor {
    return UIColor.colorComponents((241, 196, 15))
  }
  
  class func alizarin() -> UIColor {
    return UIColor.colorComponents((231, 76, 60))
  }
}

private extension UIColor {
  class func colorComponents(_ components: (CGFloat, CGFloat, CGFloat)) -> UIColor {
    return UIColor(red: components.0/255, green: components.1/255, blue: components.2/255, alpha: 1)
  }
}

extension UIViewController {
  func execAfter(delay: Double, block: @escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      block()
    }
  }
}
