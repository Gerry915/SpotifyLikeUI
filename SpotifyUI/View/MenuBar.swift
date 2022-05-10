//
//  MenuBar.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import UIKit

protocol MenuBarDelegate: AnyObject {
    func didSelectItemAtIndex(idx: Int)
}

class MenuBar: UIView {
    weak var delegate: MenuBarDelegate?
    
    lazy var playlistsButton: UIButton = makeButton(with: "Playlists")
    lazy var artistsButton: UIButton = makeButton(with: "Artists")
    lazy var albumsButton: UIButton = makeButton(with: "Albums")
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .spotifyGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var indicatorLeadingAnchor: NSLayoutConstraint!
    var indicatorTrailingAnchor: NSLayoutConstraint!
    
    var buttons: [UIButton]!
    var currentHighlightIndex: Int = 0
    
    let leadingPadding: CGFloat = 16
    let buttonSpacing: CGFloat = 36
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        buttons = [playlistsButton, artistsButton, albumsButton]
        playlistsButton.addTarget(self, action: #selector(playlistsButtonTapped), for: .primaryActionTriggered)
        artistsButton.addTarget(self, action: #selector(artistsButtonTapped), for: .primaryActionTriggered)
        albumsButton.addTarget(self, action: #selector(albumsButtonTapped), for: .primaryActionTriggered)
        
        layout()
    }
    
    func scrollToIndex(idx: Int) {
        buttons[idx].sendActions(for: .primaryActionTriggered)
        currentHighlightIndex = idx
    }
    
    func toggleHighlight(idx: Int) {
        buttons.forEach({ $0.setTitleColor(.init(white: 1.0, alpha: 0.3), for: .normal) })
        buttons[idx].setTitleColor(.init(white: 1.0, alpha: 1.0), for: .normal)
    }
    
    func updateIndicator(with offset: CGFloat) {
        let index = Int(offset / frame.width)
        // partly / total = percentage
        print(offset / frame.width)
        let atScrollStart = Int(offset) % Int(frame.width) == 0
        
        if atScrollStart {
            return
        }
        
        let percentScrolled: CGFloat
        switch index {
        case 0:
            percentScrolled = offset / frame.width - 0
        case 1:
            percentScrolled = offset / frame.width - 1
        case 2:
            percentScrolled = offset / frame.width - 2
        default:
            percentScrolled = offset / frame.width
        }
        
        var fromButton: UIButton
        var toButton: UIButton
        
        switch index {
        case 2:
            fromButton = buttons[index]
            toButton = buttons[index - 1]
        default:
            fromButton = buttons[index]
            toButton = buttons[index + 1]
        }
        
        let fromWidth = fromButton.frame.width
        let toWidth = toButton.frame.width
        
        let sectionWidth: CGFloat
        
        switch index {
        case 0:
            sectionWidth = leadingPadding + fromWidth + buttonSpacing
        default:
            sectionWidth = fromWidth + buttonSpacing
        }
        
        let sectionFraction = sectionWidth / frame.width
        let x = offset * sectionFraction
        
        let buttonWidthDiff = fromWidth - toWidth
        let widthOffset = buttonWidthDiff * percentScrolled
        
        let y: CGFloat
        switch index {
        case 0:
            if x < leadingPadding {
                y = x
            } else {
                y = x - leadingPadding * percentScrolled
            }
        case 1:
            y = x + 13
        case 2:
            y = x
        default:
            y = x
        }
        
        indicatorLeadingAnchor.constant = y
        
        let yTrailing: CGFloat
        switch index {
        case 0:
            yTrailing = y - widthOffset
        case 1:
            yTrailing = y - widthOffset - leadingPadding
        case 2:
            yTrailing = y - widthOffset - leadingPadding / 2
        default:
            yTrailing = y - widthOffset - leadingPadding
        }
        
        indicatorTrailingAnchor.constant = yTrailing
    }
    
    private func makeButton(with title: String) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitle(title, for: .normal)
        
        return btn
    }
    
    private func layout() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.addArrangedSubview(UIView())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = buttonSpacing
        
        addSubview(stackView)
        addSubview(indicatorView)
        
        indicatorLeadingAnchor = indicatorView.leadingAnchor.constraint(equalTo: playlistsButton.leadingAnchor, constant: 0)
        indicatorTrailingAnchor = indicatorView.trailingAnchor.constraint(equalTo: playlistsButton.trailingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorTrailingAnchor,
            indicatorLeadingAnchor
        ])
    }
}

extension MenuBar {
    @objc func playlistsButtonTapped() {
        delegate?.didSelectItemAtIndex(idx: 0)
        currentHighlightIndex = 0
    }
    
    @objc func artistsButtonTapped() {
        delegate?.didSelectItemAtIndex(idx: 1)
        currentHighlightIndex = 1
    }
    
    @objc func albumsButtonTapped() {
        delegate?.didSelectItemAtIndex(idx: 2)
        currentHighlightIndex = 2
    }
}
