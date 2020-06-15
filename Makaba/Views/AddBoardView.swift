//
//  AddBoardView.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 08.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class AddBoardView: UIView, UITextFieldDelegate {
    
    // MARK: - Instance Properties
    var textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var addBoardTextFieldView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Board"
        textField.layer.borderColor = #colorLiteral(red: 0.1921322048, green: 0.2078579366, blue: 0.2431031168, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.clearButtonMode = .always
        textField.delegate = self
        
        // Add left padding inside UITextView
        textField.leftView = UIView()
        textField.leftView?.frame = CGRect(x: 0, y: 0, width: 15.0, height: 36)
        textField.leftViewMode = .always
        return textField
    }()
    
    
    
    

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.9)
        
        textFieldContainerView.addSubview(addBoardTextFieldView)
        addSubview(textFieldContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateSubviewsFrame()
    }
    
    func updateSubviewsFrame() {
        textFieldContainerView.frame = CGRect(
            x: 6,
            y: self.bounds.maxY - 56 - 10,
            width: self.bounds.width - 12,
            height: 56
        )
 
        addBoardTextFieldView.frame = CGRect(
            x: 8,
            y: 8,
            width: self.bounds.width - 16 - 12,
            height: 40
        )
    }
}





