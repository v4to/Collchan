//
//  ActionSheetButton.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 10.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit


class ActionSheetButton: UIButton {
    
    // MARK: - Instance properties
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.2274276316, green: 0.2274661064, blue: 0.2352614105, alpha: 1) : #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        }
    }
    

    
    // MARK: - Initialization
    init(frame: CGRect, title: String, textColor: UIColor) {
        super.init(frame: frame)
        
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(textColor, for: UIControl.State.normal)
        backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Instance methods
    func addBottomBorder() {
        let thickness: CGFloat = 0.5
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(
            x:0, y:
            bounds.height - thickness,
            width: bounds.width,
            height:thickness
        )
        bottomBorder.backgroundColor = UIColor(#colorLiteral(red: 0.2274276316, green: 0.2274661064, blue: 0.2352614105, alpha: 1)).cgColor
        layer.addSublayer(bottomBorder)
    }
    
   override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Changing behavior of hitTest(_:, with:)
        // By default if UIButton isEnabled == false it will stop receive touch events
        // Here this behavior is altered so even it isEnabled == false it will return self
        // It will receive touch event and handle it by its internal implementation
        // Preventing it superview to handle event instead
        if !isEnabled && self.point(inside: point, with: event) { return self }
        return super.hitTest(point, with: event)
    }
}
