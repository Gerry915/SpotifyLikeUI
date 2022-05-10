//
//  ReusableView.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 9/5/2022.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reusableIdentifier: String { get }
}

extension ReusableView {
    static var reusableIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}
