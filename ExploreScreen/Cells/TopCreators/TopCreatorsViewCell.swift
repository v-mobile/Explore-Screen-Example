//
//  TopCreatorsViewCell.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia

class TopCreatorsViewCell: UICollectionViewCell {

    let containerStackView = UIStackView(frame: .zero)
    let profileView = ProfileImageView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)
    //let pollsCounterLabel = UILabel(frame: .zero)

    var profileViewTapAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        addSubviews()
        addSubviewsConstraints()
        applyStyle()
        addActions()
    }

    private func addSubviews() {
        subviews {
            containerStackView
        }
        containerStackView.arrangedSubviews {
            profileView
            nameLabel
           // pollsCounterLabel
        }
    }

    private func addSubviewsConstraints() {
        containerStackView.fillContainer()
        containerStackView.spacing = 3
        containerStackView.axis = .vertical
        profileView.heightEqualsWidth()
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.directionalLayoutMargins = .init(top: 10, leading: 0, bottom: 10, trailing: 2)
    }

    private func applyStyle() {
        nameLabel.style { (label) in
            label.textAlignment = .center
            label.textColor = .black
            label.font = R.font.proximaNovaRegular(size: 12)
        }
//        pollsCounterLabel.style { (label) in
//            label.font = R.font.proximaNovaRegular(size: 9)
//            label.textAlignment = .center
//            label.textColor = currentTheme.primaryPlaceholderColor
//            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
//            label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
//        }
    }

    private func addActions() {
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(profileViewTapped)))
    }

    @objc private func profileViewTapped() {
        profileViewTapAction?()
    }
}
