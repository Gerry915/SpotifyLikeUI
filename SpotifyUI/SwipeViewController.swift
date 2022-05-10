//
//  SwipeViewController.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import UIKit

class SwipeViewController: UIViewController {
    
    typealias SwipeHandler = (UISwipeGestureRecognizer.Direction) -> Void
    typealias PanHandler = (CGFloat, UIGestureRecognizer.State) -> Void
    
    
    var swipeHandler: SwipeHandler?
    var panHandler: PanHandler?
    
    let buttonTitle: String
    
    init(buttonTitle: String) {
        
        self.buttonTitle = buttonTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(sender:)))
        leftSwipeGesture.direction = .left
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(sender:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(leftSwipeGesture)
        view.addGestureRecognizer(rightSwipeGesture)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView(sender:)))
//        panGesture.delaysTouchesBegan = false
//        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func swipeView(sender: UISwipeGestureRecognizer) {
        swipeHandler?(sender.direction)
    }
    
    @objc private func dragView(sender: UIPanGestureRecognizer) {
        panHandler?(sender.translation(in: view).x, sender.state)
    }
    
}
