//
//  TrackCell.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 64)
        ])
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Japanese indie songs to make your day better and better"
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        
        return lb
    }()
    
    let artistLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Artist"
        lb.font = .systemFont(ofSize: 10, weight: .regular)
        lb.textColor = .init(white: 1.0, alpha: 0.5)
        
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, contentStackView])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
