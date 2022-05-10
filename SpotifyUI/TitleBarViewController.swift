//
//  TitleBarViewController.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import UIKit

class TitleBarViewController: UIViewController {
    
    let containerViewController = ContainerViewController()
    
    lazy var musicBarButton = makeBarButtonItem(title: "Music", selector: #selector(musicTapped))
    lazy var podcastsBarButton = makeBarButtonItem(title: "Podcasts", selector: #selector(podcastTapped))
    
    let viewControllers: [UIViewController]
    
    var currentIdx: Int = -1
    
    var inTransition: Bool = false
    
    init(viewControllers: [UIViewController]) {
        
        self.viewControllers = viewControllers
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        
        for case let controller as SwipeViewController in viewControllers {
            
            controller.swipeHandler = { [unowned self] direction in
                
                guard let idx = viewControllers.firstIndex(of: controller) else { return }
                
                switch direction {
                case .left:
                    guard currentIdx + 1 < viewControllers.count else { return }
                    UIView.animate(withDuration: 0.2, delay: 0.0) { [unowned self] in
                        podcastsBarButton.customView?.alpha = 1.0
                        musicBarButton.customView?.alpha = 0.3
                    }
                    containerViewController.add(viewControllers[currentIdx + 1])
                    animateTransition(fromVC: viewControllers[currentIdx], toVC: viewControllers[currentIdx + 1]) { [unowned self] done in
                        if done {
                            viewControllers[currentIdx].remove()
                            currentIdx += 1
                        }
                    }
                case .right:
                    guard currentIdx >= 1 else { return }
                    UIView.animate(withDuration: 0.2, delay: 0.0) { [unowned self] in
                        podcastsBarButton.customView?.alpha = 0.3
                        musicBarButton.customView?.alpha = 1.0
                    }
                    containerViewController.add(viewControllers[currentIdx - 1])
                    animateTransition(fromVC: viewControllers[idx], toVC: viewControllers[idx - 1]) { [unowned self] done in
                        if done {
                            viewControllers[idx].remove()
                            currentIdx -= 1
                        }
                    }
                default:
                    return
                }
            }
        }
    }
    
    private func setupView() {
        guard let containerView = containerViewController.view else { return }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        musicTapped()
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItems = [musicBarButton, podcastsBarButton]
        musicBarButton.customView?.alpha = 1.0
        
        let image = UIImage()
        
        navigationController?.navigationBar.shadowImage = image
    }
    
    private func makeBarButtonItem(title: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        var configure = UIButton.Configuration.plain()
        
        var container = AttributeContainer()
        
        container.font = .preferredFont(forTextStyle: .largeTitle).withTraits(traits: .traitBold)
        container.foregroundColor = UIColor.label
        
        configure.attributedTitle = AttributedString(title, attributes: container)
        configure.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        button.configuration = configure
        
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.alpha = 0.3
        
        return barButtonItem
    }
    
    @objc func musicTapped() {
        guard currentIdx != 0, inTransition == false else { return }
        inTransition = true
        currentIdx = 0
        
        containerViewController.add(viewControllers[0])
        
        UIView.animate(withDuration: 0.2, delay: 0.0) { [unowned self] in
            podcastsBarButton.customView?.alpha = 0.3
            musicBarButton.customView?.alpha = 1.0
        }
        
        animateTransition(fromVC: viewControllers[1], toVC: viewControllers[0]) { [weak self] done in
            if done {
                self?.viewControllers[1].remove()
                self?.inTransition = false
            }
        }
    }
    
    @objc func podcastTapped() {
        guard currentIdx != 1, inTransition == false else { return }
        inTransition = true
        currentIdx = 1
        
        UIView.animate(withDuration: 0.2, delay: 0.0) { [unowned self] in
            podcastsBarButton.customView?.alpha = 1.0
            musicBarButton.customView?.alpha = 0.3
        }
        
        containerViewController.add(viewControllers[1])
        animateTransition(fromVC: viewControllers[0], toVC: viewControllers[1]) { [weak self] done in
            if done {
                self?.viewControllers[0].remove()
                self?.inTransition = false
            }
        }
    }
    
    private func animateTransition(fromVC: UIViewController, toVC: UIViewController, completion: @escaping ((Bool) -> Void)) {
        
        guard let fromView = fromVC.view,
              let fromIndex = getIndex(forVC: fromVC),
              let toView = toVC.view,
              let toIndex = getIndex(forVC: toVC) else {
            return
        }
        
        inTransition = true
        
        let currentFrame = fromView.frame
        var fromFrameEnd = currentFrame
        var toFrameStart = currentFrame
        
        fromFrameEnd.origin.x = toIndex > fromIndex ? moveLeft(currentFrame) : moveRight(currentFrame)
        toFrameStart.origin.x = toIndex > fromIndex ? moveRight(currentFrame) : moveLeft(currentFrame)
        
        toView.frame = toFrameStart
        toView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            
            fromView.frame = fromFrameEnd
            toView.frame = currentFrame
            toView.alpha = 1.0
            
        } completion: { done in
            completion(done)
            self.inTransition = false
        }
    }
    
    private func moveLeft(_ frame: CGRect) -> CGFloat {
        return frame.origin.x - frame.width
    }
    
    private func moveRight(_ frame: CGRect) -> CGFloat {
        return frame.origin.x + frame.width
    }
    
    private func getIndex(forVC: UIViewController) -> Int? {
        viewControllers.firstIndex(of: forVC)
    }
}
