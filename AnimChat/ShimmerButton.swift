//
//  ShimmerLabel.swift
//  AnimChat
//
//  Created by Morshed Alam on 7/10/18.
//  Copyright © 2018 Morshed Alam. All rights reserved.
//

import UIKit

class ShimmerButton: UIButton,ShimmerEffect {
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    var animationDuration: TimeInterval = 3 {
        didSet { addShimmerAnimation() }
    }
    var animationDelay: TimeInterval = 1.5 {
        didSet { addShimmerAnimation() }
    }
    
    var gradientHighlightRatio: Double = 0.3 {
        didSet { addShimmerAnimation() }
    }
    
    var gradientTint: UIColor = .black {
        didSet { addShimmerAnimation() }
    }
    
    var gradientHighlight: UIColor = .white {
        didSet { addShimmerAnimation() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.mask = titleLabel?.layer
        addShimmerAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer.mask = titleLabel?.layer
        addShimmerAnimation()
    }
}
