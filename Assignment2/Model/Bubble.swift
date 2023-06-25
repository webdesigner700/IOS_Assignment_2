//
//  Bubble.swift
//  Assignment2
//
//  Created by vinay bayyapunedi on 01/05/23.
//

import Foundation
import UIKit

class Bubble: UIButton {
    //let id: 235235345345
    let xPosition = Int.random(in: 40...360)
    let yPosition = Int.random(in: 220...800)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        let probability = Int.random(in: 0...100)
        
        switch probability {
            case 0...39 :
                self.backgroundColor = .red
            case 40...69 :
            self.backgroundColor = .orange
            case 70...84 :
                self.backgroundColor = .green
            case 85...94 :
                self.backgroundColor = .blue
            case 95...100 :
                self.backgroundColor = .black
            default :
                print("Bubble won't show up")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath:"transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
}
