//
//  AddBoardView.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 08.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class AddBoardView: UIView, UITableViewDataSource {
    
    // MARK: - Instance Properties
    lazy var textFieldContainerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 6, y: self.bounds.maxY - 200, width: self.bounds.width - 12, height: 56)
        view.backgroundColor = #colorLiteral(red: 0.07449694723, green: 0.08236028999, blue: 0.08625844866, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var addBoardTextFieldView: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 10, y: 10, width: self.bounds.width - 20 - 12, height: 36)
        textField.placeholder = "Board"
        textField.layer.borderColor = #colorLiteral(red: 0.1921322048, green: 0.2078579366, blue: 0.2431031168, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.clearButtonMode = .always
        
        // Add left padding inside UITextView
        textField.leftView = UIView()
        textField.leftView?.frame = CGRect(x: 0, y: 0, width: 15.0, height: 36)
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var actionTableView: UITableView = {
        let tableView = UITableView(
            frame: CGRect(x: 6, y: self.bounds.maxY - 120, width: self.bounds.width - 12, height: 120),
            style: .plain
        )
        tableView.rowHeight = 56.0
        tableView.layer.cornerRadius = 10.0
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        return tableView
    }()
    
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        
        addBoardTextFieldView.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let cell = actionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            cell.textLabel?.textColor = textField.text == "" ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : UIColor.systemBlue
        }
    }

    
    
    // MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    func setupViews() {
        actionTableView.frame = CGRect(
            x: 6,
            y: self.bounds.maxY - 112 - 10,
            width: self.bounds.width - 12,
            height: 112
        )
        
        textFieldContainerView.frame.origin.y = self.bounds.maxY -
            actionTableView.frame.height - textFieldContainerView.frame.height - 20
        
        addBoardTextFieldView.frame = CGRect(
            x: 10,
            y: 10,
            width: self.bounds.width - 20 - 12,
            height: 36
        )
        
        textFieldContainerView.addSubview(addBoardTextFieldView)
 
        addSubview(textFieldContainerView)
        addSubview(actionTableView)
    }
    
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let identifier = "actionCell"
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
}
