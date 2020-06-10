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
    
    /*
    lazy var actionSheetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 56.0
        tableView.layer.cornerRadius = 10.0
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        return tableView
    }()
    */
    
    var actionSheetView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    var addButton: ActionSheetButton = {
        let button = ActionSheetButton(frame: .zero, title: "Favorite", textColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        button.bottomBorder = true
        button.isEnabled = false
        return button
    }()

    var cancelButton = ActionSheetButton(frame: .zero, title: "Cancel", textColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)

        addBoardTextFieldView.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.autoresizesSubviews = false
        textFieldContainerView.addSubview(addBoardTextFieldView)
        actionSheetView.addSubview(addButton)
        actionSheetView.addSubview(cancelButton)

        addSubview(textFieldContainerView)
        addSubview(actionSheetView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text! != "")
        if textField.text! == "" {
            addButton.isEnabled = false
            addButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        } else {
            addButton.isEnabled = true
            addButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    
    
    
    // MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateSubviewsFrame()
    }
    
    func updateSubviewsFrame() {
        textFieldContainerView.frame = CGRect(
            x: 6,
            y: self.bounds.maxY - 188,
            width: self.bounds.width - 12,
            height: 56
        )
 
        addBoardTextFieldView.frame = CGRect(
            x: 8,
            y: 8,
            width: self.bounds.width - 16 - 12,
            height: 40
        )
        
        /*
        actionSheetsTableView.frame = CGRect(
            x: 6,
            y: self.bounds.maxY - 112 - 10,
            width: self.bounds.width - 12,
            height: 112
        )
        */
        
        actionSheetView.frame = CGRect(
            x: 6,
            y: self.bounds.maxY - 112 - 10,
            width: self.bounds.width - 12,
            height: 112
        )
        
        addButton.frame = CGRect(
            x: 0,
            y: 0,
            width: actionSheetView.bounds.width,
            height: 56
        )
        addButton.addBottomBorder()
        
        cancelButton.frame = CGRect(
            x: 0,
            y: 56,
            width: actionSheetView.bounds.width,
            height: 56
        )
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Reseting text color just before textfield  is asked to resign the first responder status
        addButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        return true
    }
    
    
    /*
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let identifier = "actionSheetCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(
                style: .default,
               reuseIdentifier: identifier
            )
            cell?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        cell!.textLabel!.text = indexPath.row == 0 ? "Favorite" : "Cancel"
        cell!.textLabel?.font = UIFont.systemFont(
            ofSize: cell!.textLabel!.font.pointSize,
            weight: UIFont.Weight.bold
        )
        cell!.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell!.separatorInset = UIEdgeInsets.zero
        if indexPath.row == 1 {
            // Remove bottom border
            cell!.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: UIScreen.main.bounds.width

            )
            cell!.textLabel?.textColor = UIColor.systemBlue
            
        }
        cell!.textLabel?.textAlignment = .center
        cell!.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        return cell!
    }
    */
}





