//
//  TopCategoriesViewCell.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia
import SkeletonView

class TopCategoriesViewCell: UICollectionViewCell {

    let imageView = UIImageView(frame: .zero)
    let containerStackView = UIStackView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)
    let overlayView = Gradient(frame: .zero)

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
        isSkeletonable = true
        imageView.isSkeletonable = true
        nameLabel.isSkeletonable = true
    }

    private func addSubviews() {
        subviews {
            imageView
            containerStackView
        }
        containerStackView.arrangedSubviews {
            nameLabel
        }
        imageView.subviews {
            overlayView
        }
    }

    private func addSubviewsConstraints() {
        containerStackView.axis = .vertical
        containerStackView.spacing = 2
        containerStackView.fillHorizontally(padding: 9)
        containerStackView.Bottom == Bottom - 9
        imageView.fillContainer()
        overlayView.Width == imageView.Width
        overlayView.Height == imageView.Height/2 - 15
        overlayView.Bottom == imageView.Bottom
    }

    private func applyStyle() {
        nameLabel.style { (label) in
            label.textColor = .white
            label.font = R.font.proximaNovaBold(size: 12)
        }
        overlayView.startColor = UIColor.clear
        overlayView.endColor = UIColor.black.withAlphaComponent(0.2)
        imageView.style { (imageView) in
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }
}
