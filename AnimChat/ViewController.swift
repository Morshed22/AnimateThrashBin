//
//  ViewController.swift
//  AnimChat
//
//  Created by Morshed Alam on 6/10/18.
//  Copyright © 2018 Morshed Alam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var recordView:MARecordView!
    
    @IBOutlet weak var button: UIButton!
    private var recordViewConstraint:NSLayoutConstraint!
    
//    private var imageView :UIImageView = {
//        let imageview = UIImageView()
//        imageview.translatesAutoresizingMaskIntoConstraints = false
//        imageview.image = #imageLiteral(resourceName: "input_mic.png")
//        imageview.contentMode = .scaleAspectFill
//        imageview.isUserInteractionEnabled = true
//        return imageview
//    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        recordView = MARecordView()
        recordView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recordView)
       // self.view.addSubview(imageView)
        
        
//        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
//          imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//         imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:
//            -10).isActive = true
        
        
        
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLognPressGesture(gestureRecognizer:)))
//        gesture.minimumPressDuration = 0.1
//        self.imageView.addGestureRecognizer(gesture)
        

        recordViewConstraint = recordView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:0)
        recordViewConstraint.isActive = true
        recordView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        recordView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-100).isActive = true
        recordView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    
    @IBAction func clickMe(_ sender: UIButton) {
        
        recordView.microDriveUpAnimation()
       
    }
    
//    @objc func handleLognPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
//
//        if gestureRecognizer.state == .began{
//            recordViewConstraint.constant = 0
//            UIView.animate(withDuration: 0.2) {
//                self.view.layoutIfNeeded()
//            }
//        }
//        recordView.handlePanGesture(gestureRecognizer: gestureRecognizer)
//    }
    
    
   
    
}



