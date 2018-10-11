//
//  MARecordView.swift
//  AnimChat
//
//  Created by Morshed Alam on 7/10/18.
//  Copyright © 2018 Morshed Alam. All rights reserved.
//

import UIKit

class MARecordView: UIView {

    private var kAnimationNameKey = "animation_name"
    private var microDriveUpAnimationName = "micro_drive_up_animation"
    private var microDriveDownAnimationName = "micro_drive_down_animation"
    private var bucketDriveUpAnimationName = "bucket_drive_up_animation"
    private var bucketDriveDownAnimationName = "bucket_drive_down_animation"
    private var opacityAnimationName = "opacity"
    private let microDriveUpAnimationHeight: CGFloat = 100
    
    var scrapLayer: CALayer?
    var bucketContainerLayer: CALayer?
    
    var bucket: MABucketView = {
        let bucket = MABucketView()
        bucket.translatesAutoresizingMaskIntoConstraints = false
        return bucket
    }()
    
    var duration: CFTimeInterval = 0.6

    
  
    private lazy var shimmerButton: ShimmerButton = {
        let button = ShimmerButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("slide to cancel<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:17, weight: .light)
        button.gradientTint = .lightGray
        button.layer.zPosition = 99
        button.gradientHighlight = .black
        button.sizeToFit()
        return button
    }()
    
    private lazy var micImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "input_mic").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .red
        label.numberOfLines = 1
        label.text = "00:00"
        label.backgroundColor = .white
        label.layer.zPosition = 100
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private var centerXConstraint:NSLayoutConstraint!
    private var originalXCenter: CGFloat!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   
    private func setConstraints(){
        centerXConstraint =  shimmerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        centerXConstraint.isActive = true
        shimmerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        shimmerButton.widthAnchor.constraint(equalToConstant: 122).isActive = true
        shimmerButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        timerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 31).isActive = true
        timerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        micImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        micImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        micImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        micImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        
        bucket.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bucket.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bucket.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bucket.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bucket.layer.isHidden = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startBlink(){
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.autoreverses = true
        animation.repeatCount = HUGE
        scrapLayer!.add(animation, forKey: "opacity")
    }
    

    func initUI(){
        
        
        self.addSubview(bucket)
        self.addSubview(shimmerButton)
        self.addSubview(timerLabel)
        self.addSubview(micImageView)
        self.setConstraints()
        

        self.scrapLayer = micImageView.layer
        self.scrapLayer?.frame = micImageView.bounds
        
        

       // startBlink()
        
        
    }
    
     func handlePanGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let sender = gestureRecognizer.view else { return }
        let limit = self.bounds.maxX/2 + sender.bounds.maxX
        //print(limit)
        
        switch gestureRecognizer.state {
        case .began:
            originalXCenter =  centerXConstraint.constant
        case .changed:
            let translation = gestureRecognizer.location(in: self.superview)
            if translation.x <= limit {
              shimmerButton.isHidden = true
              scrapLayer?.removeAnimation(forKey: "opacity")
              self.microDriveUpAnimation()
              gestureRecognizer.isEnabled = false
            }
            centerXConstraint.constant =  translation.x - (self.bounds.maxX - sender.bounds.maxX)
           // print(translation.x, centerXConstraint.constant)
            let percentage = abs(centerXConstraint.constant/limit)
            shimmerButton.titleLabel?.alpha = 1 - percentage*2
            sender.alpha = percentage*2
             //print(percentage)
        case.ended:
            print("go for chat sound")
        default:
            break
        }
     
        

    }
    
    
    func microDriveUpAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: scrapLayer!.position)
        moveAnimation.toValue = NSValue(cgPoint: CGPoint(x: scrapLayer!.frame.midX, y: scrapLayer!.frame.midY - microDriveUpAnimationHeight))
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let keyFrameValues = [0.0, .pi, (.pi * 1.5), (.pi * 2.0)]
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform")
        rotateAnimation.values = keyFrameValues
        rotateAnimation.valueFunction = CAValueFunction(name: .rotateZ)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = .forwards
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let animGroup = CAAnimationGroup.init()
        animGroup.delegate = self
        animGroup.setValue(microDriveUpAnimationName, forKey: kAnimationNameKey)
        animGroup.animations = [moveAnimation, rotateAnimation]
        animGroup.duration = duration
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        scrapLayer!.add(animGroup, forKey: nil)
    }
    
    
    func microDriveDownAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.delegate = self
        moveAnimation.setValue(microDriveDownAnimationName, forKey: kAnimationNameKey)
        moveAnimation.toValue = NSValue(cgPoint: CGPoint(x: scrapLayer!.position.x, y: scrapLayer!.position.y))
        moveAnimation.duration = duration
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        scrapLayer!.add(moveAnimation, forKey: nil)
    }

    func bucketDriveUpAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.delegate = self
        moveAnimation.setValue(bucketDriveUpAnimationName, forKey: kAnimationNameKey)
        moveAnimation.fromValue = NSValue(cgPoint: bucket.layer.position)
        moveAnimation.toValue = NSValue(cgPoint: CGPoint(x: scrapLayer!.position.x, y:scrapLayer!.frame.minY-scrapLayer!.frame.height))
        moveAnimation.duration = duration
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        bucket.layer.add(moveAnimation, forKey: nil)
    }
    
    func bucketDriveDownAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.delegate = self
        moveAnimation.setValue(bucketDriveDownAnimationName, forKey: kAnimationNameKey)
        moveAnimation.toValue = NSValue(cgPoint: bucket.layer.position)
        moveAnimation.duration = duration
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        bucket.layer.add(moveAnimation, forKey: nil)
    }

}

extension MARecordView:CAAnimationDelegate{
    
    func animationDidStart(_ anim: CAAnimation) {
        
        let animationName =  anim.value(forKey: kAnimationNameKey) as! String
        print(animationName)
        if (animationName == microDriveDownAnimationName) {
            bucketDriveUpAnimation()
        } else if (animationName == bucketDriveUpAnimationName) {
            bucket.layer.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.bucket.openBucket()
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            let animationName = anim.value(forKey: kAnimationNameKey) as! String
            if (animationName == microDriveUpAnimationName) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.microDriveDownAnimation()
                }
                
            } else if (animationName == microDriveDownAnimationName) {
                scrapLayer!.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.bucket.closeBucket()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.bucketDriveDownAnimation()
                }
                
            } else if (animationName == bucketDriveDownAnimationName) {
                bucket.layer.isHidden = true
                scrapLayer!.isHidden = false

            }
        }
    }
}

