//
//  MABucket.swift
//  AnimChat
//
//  Created by Morshed Alam on 6/10/18.
//  Copyright © 2018 Morshed Alam. All rights reserved.
//

import Foundation
import UIKit


 protocol MABucketDelegate {
      func openAnimationDidStart()
      func openAnimationDidFinish()
      func closeAnimationDidStart()
      func closeAnimationDidFinish()
}


class MABucketView:UIView {
    
    private var openingKeyPath = "transform.rotation.z"
    private var openKeyName = "open"
    private var closeKeyName = "close"
    private func degreesToRadians(_ degrees: CGFloat) -> CGFloat{
        return   (degrees * .pi / 180)
    }
    
    
    var animationDuration: CFTimeInterval = 0
    var animationTimingFunction: CAMediaTimingFunction?
    var degreesVariance: CGFloat = 0.0
    var interspace: CGFloat = -3.0
    
    var buckeTopAnchorPoint:CGPoint = .zero{
        didSet{
            self.bucketLidLayer?.anchorPoint = buckeTopAnchorPoint
            self.bucketBodyLayer?.anchorPoint = .zero
            self.setLayerFrame()
        }
    }
    

    
    private var bucketLidLayer: CALayer?
       
    private var bucketBodyLayer: CALayer?
        
    
    private var bucketTopImageView :UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "BucketLid")
        imageview.contentMode = .scaleToFill
        return imageview
    }()
    
    private var bucketBodyImageView :UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "BucketBody")
        imageview.contentMode = .scaleToFill
        return imageview
    }()
    
    
     var bucketDelegate: MABucketDelegate?

    func setPropertiesValue(){
        animationDuration = 0.1
        animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        degreesVariance = -135
        interspace = -3
        buckeTopAnchorPoint = CGPoint(x: 0.01, y: 1)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        
        
        self.addSubview(bucketBodyImageView)
        self.addSubview(bucketTopImageView)
        self.setConstraints()
        
        bucketLidLayer = bucketTopImageView.layer
        bucketBodyLayer = bucketBodyImageView.layer
        self.layer.addSublayer(bucketLidLayer!)
        self.layer.addSublayer(bucketBodyLayer!)
        setPropertiesValue()
    }

    private func setConstraints(){
        
        let bucketTopImageSize = #imageLiteral(resourceName: "BucketLid").size
        let bucketBodyImageSize = #imageLiteral(resourceName: "BucketBody").size
        
        bucketTopImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bucketTopImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bucketTopImageView.heightAnchor.constraint(equalToConstant: bucketTopImageSize.height).isActive = true
        bucketTopImageView.widthAnchor.constraint(equalToConstant: bucketTopImageSize.width).isActive = true
        
        bucketBodyImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bucketBodyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:bucketTopImageSize.height+interspace).isActive = true
        bucketBodyImageView.heightAnchor.constraint(equalToConstant: bucketBodyImageSize.height).isActive = true
        bucketBodyImageView.widthAnchor.constraint(equalToConstant: bucketBodyImageSize.width).isActive = true
        
        
    }
    
    
    
    private func setLayerFrame() {
  
        bucketLidLayer?.frame = bucketTopImageView.bounds
        bucketBodyLayer?.frame = bucketTopImageView.bounds
       
    }
    
    
    func openBucket() {
        let animation = CAKeyframeAnimation(keyPath: openingKeyPath)
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        var values: [AnyHashable] = []
        var timings: [AnyHashable] = []
        values.append(degreesToRadians(0))
        if let aFunction = animationTimingFunction {
            timings.append(aFunction)
        }
        values.append(degreesToRadians(degreesVariance))
        if let aFunction = animationTimingFunction {
            timings.append(aFunction)
        }
        animation.values = values
        animation.timingFunctions = timings as? [CAMediaTimingFunction]
        bucketLidLayer!.add(animation, forKey: openKeyName)
    }
    
    func closeBucket() {
        let animation = CAKeyframeAnimation(keyPath: openingKeyPath)
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        var values: [AnyHashable] = []
        var timings: [AnyHashable] = []
        values.append(degreesToRadians(degreesVariance))
        if let aFunction = animationTimingFunction {
            timings.append(aFunction)
        }
        values.append(degreesToRadians(0))
        if let aFunction = animationTimingFunction {
            timings.append(aFunction)
        }
        animation.values = values
        animation.timingFunctions = timings as? [CAMediaTimingFunction]
        bucketLidLayer!.add(animation, forKey: closeKeyName)
    }

}


extension MABucketView : CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        let keyPath = (anim as? CAKeyframeAnimation)?.keyPath
        
        guard let delegate = bucketDelegate  else { return }
        
        if (keyPath == openKeyName) {
            delegate.openAnimationDidStart()
        } else if (keyPath == closeKeyName) {
            delegate.closeAnimationDidStart()
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        let keyPath = (anim as? CAKeyframeAnimation)?.keyPath
        guard let delegate = bucketDelegate  else { return }
        
        if (keyPath == openKeyName) {
            delegate.openAnimationDidFinish()
        } else if (keyPath == closeKeyName) {
            delegate.closeAnimationDidFinish()
        }
    }
    
}
