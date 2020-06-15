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
    // MARK: - Instance Properties
    private var starImageFrameSaved = CGPoint()
    private var originSaved = CGPoint()
    private var canPlayHapticFeedback = true
    private let actionView: UIView = {
        let view = UIView()
        view.isHidden = true
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
    
    var starImage: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: "star.fill", withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        
        var imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        actionView.addSubview(starImage)
        
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
        print("layoutSubview")
        actionView.frame = self.bounds
        
        starImage.frame = self.bounds
        starImage.frame.size.width += starImage.image!.size.width + 15
        starImage.contentMode = .right
        starImageFrameSaved = starImage.frame.origin
    }
    
    // MARK: - UIGestureRecognizerDelegate

    override func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            
            // if horizontalComponent of velocity is greater than vertical that
            // means pan gesture is moving in horizontal direction(swipe alike)
            // and so pan gesture of contentView should begin
            let horizontalComponent = abs(panGesture.velocity(in: self).x)
            let verticalComponent = abs(panGesture.velocity(in: self).y)
            return horizontalComponent > verticalComponent
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
           
            
            self.contentView.backgroundColor = self.backgroundColor
        case .changed:
            if let gestureView = panGesture.view {
                self.actionView.isHidden = false
                if panGesture.translation(in: self).x > 0 {
                    actionView.backgroundColor = nil
                } else {
                    actionView.backgroundColor = #colorLiteral(red: 0, green: 0.6745420694, blue: 0.2156436443, alpha: 1)
                }
                
                gestureView.frame.origin.x = panGesture.translation(in: self).x
            
                if abs(panGesture.translation(in: self).x) < starImage.image!.size.width + 30.0 {
                    starImage.frame.origin.x = panGesture.translation(in: self).x
                } else {
                    starImage.frame.origin.x = starImageFrameSaved.x - (starImage.image!.size.width + 30)
                }
                
                if
                    (gestureView.frame.origin.x < CGFloat(-50.0)) &&
                    canPlayHapticFeedback
                {
                    let systemSoundID = SystemSoundID(1519)
                    AudioServicesPlaySystemSound(systemSoundID)
                    canPlayHapticFeedback = false
                }
                if gestureView.frame.origin.x > CGFloat(-50.0) {
                    canPlayHapticFeedback = true
                }
                
            }
        case .ended:
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    panGesture.view?.frame.origin = self.originSaved
                    
                    let star = self.starImage
                    if abs(panGesture.translation(in: self).x) > star.image!.size.width + 30.0 {
                        star.frame.origin = self.starImageFrameSaved
                        star.frame.origin.x = self.starImageFrameSaved.x - (star.image!.size.width + 30)
                    } else {
                        star.frame.origin = self.starImageFrameSaved
                    }
                },
                completion: { finished in
                    self.contentView.backgroundColor = nil
                    self.actionView.isHidden = true
                }
            )
            canPlayHapticFeedback = true
        default:
            break
        }
    }
}
