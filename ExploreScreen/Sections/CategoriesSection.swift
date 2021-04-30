//
//  CategoriesSection.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia
import SkeletonView

class CategoriesSection: UIStackView {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 10)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let titleLabel = PaddingLabel(insets: UIEdgeInsets.init(top: 0,
                                                            left: 16,
                                                            bottom: 0,
                                                            right: 0))

    var categories: [Category] = [] {
        didSet {
            collectionView.hideSkeleton()
            collectionView.reloadData()
        }
    }

    var onSelection: ((Category) -> Void)?

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
        collectionView.register(TopCategoriesViewCell.self,
                                forCellWithReuseIdentifier: TopCategoriesViewCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
    }

    private func addSubviews() {
        arrangedSubviews {
            titleLabel
            collectionView
        }
    }

    private func addSubviewsConstraints() {
        spacing = 17
        axis = .vertical
    }

    private func applyStyle() {
        titleLabel.style { (label) in
            label.font = R.font.proximaNovaBold(size: 17)
            label.textColor = currentTheme.primaryTextColor
            label.text = R.string.localizable.top_categories()
        }
        collectionView.backgroundColor = .clear
    }
}

extension CategoriesSection: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TopCategoriesViewCell.description()
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: TopCategoriesViewCell.description(),
                                     for: indexPath) as? TopCategoriesViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: category.image), placeholderImage: R.image.tempImage())
        cell.nameLabel.text = category.label
        //cell.postsCountLabel.text = "\(category.pollsCount.description) \(R.string.localizable.posts())"
        return cell
    }
}

extension CategoriesSection: CollectionViewWaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onSelection?(categories[indexPath.item])
    }
}
