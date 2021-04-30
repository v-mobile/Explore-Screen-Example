//
//  TopStoriesViewCell.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia

class TopPollsViewCell: UICollectionViewCell {

    let headerView = HeaderView(frame: .zero)
    let containerView = UIView(frame: .zero)
    let imagePollContainerView = ImagePollsContainerView(frame: .zero)
    let textPollContainerView = TextPollsContainerView(frame: .zero)
    let footerView = TopPollsFooterView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    func showImagePoll() {
        imagePollContainerView.isHidden = false
        textPollContainerView.isHidden = true
    }

    func showTextPoll() {
        imagePollContainerView.isHidden = true
        textPollContainerView.isHidden = false
    }

    private func initialize() {
        addSubviews()
        addSubviewsConstraints()
        imagePollContainerView.initialize()
        textPollContainerView.initialize()
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = currentTheme.secondaryTextColor
        headerView.titleLabel.font = R.font.proximaNovaBold(size: 11)
        containerView.addCardShadow()
    }

    private func addSubviews() {
        subviews {
            containerView
            headerView
            imagePollContainerView
            textPollContainerView
            footerView
        }
    }

    private func addSubviewsConstraints() {
        containerView.fillContainer(padding: 2)
        headerView.Height == 52
        headerView.Top == Top
        headerView.Left == Left - 10
        headerView.Right == Right + 10
        footerView.Leading == Leading
        footerView.Trailing == Trailing
        footerView.Height == 37
        footerView.Bottom == Bottom
        footerView.Top == imagePollContainerView.Bottom + 2
        footerView.Top == textPollContainerView.Bottom
        imagePollContainerView.Top == headerView.Bottom
        textPollContainerView.Top == headerView.Bottom
        imagePollContainerView.Height == 104
        textPollContainerView.Height == 104
    }
}
