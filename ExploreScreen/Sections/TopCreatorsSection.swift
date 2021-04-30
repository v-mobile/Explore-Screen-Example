//
//  TopCreatorsSection.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import SkeletonView

class TopCreatorsSection: UIStackView {

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

    var creators: [UserStoryData] = [] {
        didSet {
            collectionView.hideSkeleton()
            collectionView.reloadData()
        }
    }
    let adapter = TopCreatorsAdapter()

    var onSelection: ((UserStoryData) -> Void)?
    var onStorySelection: ((UserStoryData) -> Void)?

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
        collectionView.register(TopCreatorsViewCell.self,
                                forCellWithReuseIdentifier: TopCreatorsViewCell.description())
        collectionView.register(ShimmeringUserCell.self,
                                forCellWithReuseIdentifier: ShimmeringUserCell.description())
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
            label.text = R.string.localizable.top_creators()
        }
        collectionView.backgroundColor = .clear
    }
}

extension TopCreatorsSection: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ShimmeringUserCell.description()
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return creators.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: TopCreatorsViewCell.description(),
                                     for: indexPath) as? TopCreatorsViewCell else {
            return UICollectionViewCell()
        }
        let creator = creators[indexPath.item]
        adapter.configure(cell: cell, item: creator)
        cell.profileViewTapAction = { [weak self] in
            self?.onStorySelection?(creator)
        }
        return cell
    }
}

extension TopCreatorsSection: CollectionViewWaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 115)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onSelection?(creators[indexPath.item])
    }
}
