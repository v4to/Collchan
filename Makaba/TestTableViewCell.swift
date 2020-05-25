//
//  TestTableViewCell.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 24.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import AudioToolbox

class BoardsListTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private var originSaved = CGPoint()
    private var canPlayHapticFeedback = true
    private let actionView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.8431372643, blue: 0.2941176593, alpha: 1)
        return view
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        
        // set up delegate to resolve pan gesture conflict with UITabliewView
        // pan gesture using gestureRecognizerShouldBegin method
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(actionView)
        sendSubviewToBack(actionView)
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = self.backgroundColor
        actionView.frame = self.bounds
    }
    
    // MARK: - UIGestureRecognizerDelegate

    override func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            
            // if horizontalComponent of velocity is greater than vertical that
            // means pan gesture is moving in horizontal direction(swipe alike)
            // and so pan gesture of contentView should begin
            let horizontaComponent = abs(panGesture.velocity(in: self).x)
            let verticalComponent = abs(panGesture.velocity(in: self).y)
            return horizontaComponent > verticalComponent
        }
        
        // otherwise ignore pan gesture of contentView in favor of parent
        // contentView pan gesture
        return false
    }
    
    // MARK: - Gestures
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            originSaved = panGesture.view!.frame.origin
        case .changed:
            if let gestureView = panGesture.view {
                gestureView.frame.origin.x = panGesture.translation(in: self).x
                if (gestureView.frame.origin.x < CGFloat(-50.0)) &&
                   canPlayHapticFeedback {
                    let systemSoundID = SystemSoundID(1519)
                    AudioServicesPlaySystemSound(systemSoundID)
                    canPlayHapticFeedback = false
                }
                if gestureView.frame.origin.x > CGFloat(-50.0) {
                    canPlayHapticFeedback = true
                }
            }
        case .ended:
            UIView.animate(withDuration: 0.2) {
                panGesture.view?.frame.origin = self.originSaved
            }
            canPlayHapticFeedback = true
        default:
            break
        }
    }
}
