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
    var isChosen = false {
        didSet {
            if isChosen {
                starImage.image = generateImage(withName:"star.slash.fill")
            } else {
                starImage.image = generateImage(withName:"star.fill")
            }
            
        }
    }
    
    var actionViewBackgroundColor: UIColor {
        return isChosen ? #colorLiteral(red: 0.9451245666, green: 0, blue: 0.008069912903, alpha: 1) : #colorLiteral(red: 0, green: 0.6745420694, blue: 0.2156436443, alpha: 1)
    }
    
    var delegate: SwipeableCellDelegate?
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator? = nil
    
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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        actionView.addSubview(starImage)
        
        addSubview(actionView)
        sendSubviewToBack(actionView)
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: - Instance Methods
    func generateImage(withName name: String) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        var image = UIImage(systemName: name, withConfiguration: configuration)!
        image = image.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        return image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionView.frame = self.bounds
        
        // additional 50 offset to avoid glitch in animation
        actionView.frame.size.width += starImage.image!.size.width + 30 + 50
        
        starImage.frame.size.width = starImage.image!.size.width
        starImage.frame.size.height = self.bounds.height
        starImage.frame.origin.x = actionView.bounds.maxX - starImage.image!.size.width - 15 - 50
    }
    
    
    
    
    
    // MARK: - UIGestureRecognizerDelegate
    override func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            if (panGesture.velocity(in: self).x > 0) { return false}
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
            impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            originSaved = panGesture.view!.frame.origin
            self.contentView.backgroundColor = self.backgroundColor
        case .changed:
            if let gestureView = panGesture.view {
                self.actionView.isHidden = false
                if panGesture.translation(in: self).x > 0 {
                    actionView.backgroundColor = nil
                } else {
//                    actionView.backgroundColor = #colorLiteral(red: 0, green: 0.6745420694, blue: 0.2156436443, alpha: 1)
                    actionView.backgroundColor = actionViewBackgroundColor
                }
                
                gestureView.frame.origin.x = panGesture.translation(in: self).x

                if abs(panGesture.translation(in: self).x) >= (starImage.image!.size.width + 30) {
                    actionView.frame.origin.x = originSaved.x - (starImage.image!.size.width + 30)
                }
                
                if abs(panGesture.translation(in: self).x) < (starImage.image!.size.width + 30) {
                    actionView.frame.origin.x = gestureView.frame.origin.x
                }
                
                
                if
                    (gestureView.frame.origin.x < CGFloat(-(starImage.image!.size.width + 30))) &&
                    canPlayHapticFeedback
                {
                    
                    let systemSoundID = SystemSoundID(1519)
                    AudioServicesPlaySystemSound(systemSoundID)
                    
                    impactFeedbackGenerator?.prepare()
                    impactFeedbackGenerator?.impactOccurred()
                    
                    UIView.animate(
                        withDuration: 0.1,
                        animations: {
                            self.starImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        },
                        completion: { isCompleted  in
                            UIView.animate(withDuration: 0.1) {
                                self.starImage.transform = CGAffineTransform.identity
                            }
                        }
                    )
                    canPlayHapticFeedback = false
                    
                    
                }
                
                if gestureView.frame.origin.x > CGFloat(-(starImage.image!.size.width + 30)) {
                    canPlayHapticFeedback = true
                }
                
            }
        case .ended:
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    panGesture.view?.frame.origin = self.originSaved
                    
                    // animate back if full icon is not showed
                    if abs(panGesture.translation(in: self).x) < self.starImage.image!.size.width + 30 {
                        self.actionView.frame.origin = self.originSaved
                    }
                    
                    
                },
                completion: { finished in
                    self.actionView.frame.origin = self.originSaved
                    self.contentView.backgroundColor = nil
                    self.actionView.isHidden = true
                    
                    if
                        let delegate = self.delegate,
                        !self.canPlayHapticFeedback {
                        delegate.cellDidSwipe(cell: self)
                    }
                    
                    self.canPlayHapticFeedback = true
                }
            )
           
            
            impactFeedbackGenerator = nil
            
        default:
            break
        }
    }
}


protocol SwipeableCellDelegate {
    func cellDidSwipe(cell: BoardsListTableViewCell)
}
