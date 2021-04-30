//
//  TopStoriesFooterView.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia

class TopPollsFooterView: UIStackView {

    let votersLabel = UILabel(frame: .zero)
    let tempView = UIView(frame: .zero)
    let dotView = RoundedImageView(frame: .zero)
    let daysLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        addSubviews()
        addSubviewsConstraints()
        applyStyle()
    }

    private func addSubviews() {
        arrangedSubviews {
            votersLabel
            tempView
            daysLabel
        }
        tempView.subviews {
            dotView
        }
    }

    private func addSubviewsConstraints() {
        spacing = 7
        dotView.Height == 2
        dotView.heightEqualsWidth()
        dotView.centerInContainer()
        tempView.Width == 2
        tempView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tempView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        votersLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        votersLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        isLayoutMarginsRelativeArrangement = true
    }

    private func applyStyle() {
        votersLabel.font = R.font.proximaNovaRegular(size: 10)
        daysLabel.font = R.font.proximaNovaRegular(size: 10)
        dotView.backgroundColor = currentTheme.primaryPlaceholderColor
        votersLabel.textColor = currentTheme.primaryPlaceholderColor
        daysLabel.textColor = currentTheme.primaryPlaceholderColor
        tempView.backgroundColor = .clear
    }
}
