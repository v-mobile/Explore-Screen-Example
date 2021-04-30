//
//  TopStoriesSection.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia
import SkeletonView

class TopPollsSection: UIStackView {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 10)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let topContainerView = UIStackView(frame: .zero)
    let titleLabel = PaddingLabel(insets: .zero)
    let showMoreButton = UIButton(frame: .zero)

    var polls: [PollData] = [] {
        didSet {
            showMoreButton.isHidden = false
            collectionView.hideSkeleton()
            collectionView.reloadData()
        }
    }
    let adapter = TopPollsAdapter()

    var onSelection: ((Int) -> Void)?

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
        collectionView.register(TopPollsViewCell.self,
                                forCellWithReuseIdentifier: TopPollsViewCell.description())
        collectionView.register(ShimmeringMyPollsCell.self,
                                forCellWithReuseIdentifier: ShimmeringMyPollsCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
        showMoreButton.addTarget(self, action: #selector(onShowMoreTapped), for: .touchUpInside)
    }

    private func addSubviews() {
        topContainerView.arrangedSubviews {
            titleLabel
            showMoreButton
        }
        arrangedSubviews {
            topContainerView
            collectionView
        }
    }

    private func addSubviewsConstraints() {
        axis = .vertical
        spacing = 17
        showMoreButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        showMoreButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        collectionView.backgroundColor = .clear
        topContainerView.isLayoutMarginsRelativeArrangement = true
        topContainerView.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }

    private func applyStyle() {
        titleLabel.style { (label) in
            label.font = R.font.proximaNovaBold(size: 17)
            label.textColor = currentTheme.primaryTextColor
            label.text = R.string.localizable.top_polls()
        }
        showMoreButton.style { (button) in
            button.titleLabel?.font = R.font.proximaNovaRegular(size: 11)
            button.setTitle(R.string.localizable.show_more(), for: .normal)
            button.setTitleColor(currentTheme.primaryActionBackgroundColor, for: .normal)
            button.setImage(R.image.topPollsArrrow(), for: .normal)
            button.isHidden = true
            button.imageToRight()
            button.imageEdgeInsets = .init(top: 2, left: -5, bottom: 0, right: 0)
        }
    }

    @objc private func onShowMoreTapped() {
        onSelection?(0)
    }
}

extension TopPollsSection: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ShimmeringMyPollsCell.description()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return polls.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: TopPollsViewCell.description(),
                                     for: indexPath) as? TopPollsViewCell else {
            return UICollectionViewCell()
        }
        let poll = polls[indexPath.item]
        adapter.configure(cell: cell, item: poll)
        return cell
    }
}

extension TopPollsSection: CollectionViewWaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 242, height: 195)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onSelection?(indexPath.item)
    }
}
