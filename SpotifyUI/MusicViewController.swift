//
//  MusicViewController.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import UIKit

class MusicViewController: SwipeViewController {
    
    private let sample = Array(repeating: 1, count: 3)
    
    let menuBar = MenuBar()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: createLayout())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackListCell.self, forCellWithReuseIdentifier: TrackListCell.reusableIdentifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        menuBar.delegate = self
        
        NSLayoutConstraint.activate([
            menuBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 48),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
    }
    
    private func createLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
         
        section.visibleItemsInvalidationHandler = { [weak self] visibleItem, offset, env in
            self?.collectionViewDidScroll(offset: offset)
        }
        
        
        return section
    }
    
    private func collectionViewDidScroll(offset: CGPoint) {
        
        menuBar.updateIndicator(with: offset.x)
        
        let collectionWidth = collectionView.frame.width
        let page = offset.x / collectionWidth
        
        switch page {
        case 0:
            menuBar.scrollToIndex(idx: Int(page))
        case 1:
            menuBar.scrollToIndex(idx: Int(page))
        case 2:
            menuBar.scrollToIndex(idx: Int(page))
        default:
            break
        }
        
    }
}

extension MusicViewController: MenuBarDelegate {
    func didSelectItemAtIndex(idx: Int) {
        menuBar.toggleHighlight(idx: idx)
        collectionView.scrollToItem(at: IndexPath(row: idx, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension MusicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sample.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackListCell.reusableIdentifier, for: indexPath)
        
        return cell
    }
}
