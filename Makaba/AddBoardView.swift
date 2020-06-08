//
//  AddBoardView.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 08.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class AddBoardView: UIView {
    
    // MARK: - Instance Properties
    lazy var textFieldContainerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.bounds.maxY, width: self.bounds.width, height: 60)
        view.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var addBoardTextFieldView: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 10, y: 10, width: self.bounds.width - 20, height: 40)
        textField.placeholder = "Board"
        textField.layer.borderColor = #colorLiteral(red: 0.1921322048, green: 0.2078579366, blue: 0.2431031168, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.clearButtonMode = .always
        
        // Add left padding inside UITextView
        textField.leftView = UIView()
        textField.leftView?.frame = CGRect(x: 0, y: 0, width: 15.0, height: 40)
        textField.leftViewMode = .always
        return textField
    }()
    
    
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Instance Methods
    override func layoutSubviews() {
        setupViews()
    }
    
    func setupViews() {
        textFieldContainerView.addSubview(addBoardTextFieldView)
        addSubview(textFieldContainerView)
    }

    
    
}
