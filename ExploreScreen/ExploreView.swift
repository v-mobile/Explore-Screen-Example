//
//  ExploreView.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright (c) 2021 V-Mobile. All rights reserved.
//

import UIKit
import Stevia

enum ExploreListType {
    case topPolls(polls: [PollData], selectedIndex: Int)
    case fromCategory(categoryId: Int)
}

protocol ExploreViewOutput: AnyObject {
    func openList(type: ExploreListType, title: String)
    func openUserProfile(storyData: UserStoryData)
    func openStories(storyData: UserStoryData)
}

final class ExploreView: ThemedView {

    weak var output: ExploreViewOutput?
    let containerView = UIStackView(frame: .zero)
    let scrollView = UIScrollView(frame: .zero)
    let categoriesSection = CategoriesSection(frame: .zero)
    let topCreatorsSection = TopCreatorsSection(frame: .zero)
    let topPollsSection = TopPollsSection(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func apply(theme: Theme) {
        backgroundColor = theme.mainBackgroundColor
    }

    private func initialize() {
        addSubviews()
        addSubviewsConstraints()
        handleSelections()
    }

    private func addSubviews() {
        subviews {
            scrollView
        }
        scrollView.subviews {
            containerView
        }
        containerView.arrangedSubviews {
            topPollsSection
            topCreatorsSection
            categoriesSection
        }
    }

    private func addSubviewsConstraints() {
        scrollView.fillHorizontally()
        scrollView.Bottom == safeAreaLayoutGuide.Bottom
        scrollView.Top == safeAreaLayoutGuide.Top + 30
        containerView.Trailing == scrollView.Trailing
        containerView.centerHorizontally()
        containerView.Top == scrollView.Top
        containerView.Width == scrollView.Width
        containerView.Bottom == scrollView.Bottom - 100
        containerView.spacing = 30
        topPollsSection.Height == 240
        topCreatorsSection.Height == 135
        categoriesSection.Height == 160
        containerView.axis = .vertical
    }

    private func handleSelections() {
        topPollsSection.onSelection = { [weak self] index in
            guard let self = self else {
                return
            }
            self.output?.openList(type: .topPolls(polls: self.topPollsSection.polls, selectedIndex: index),
                                  title: R.string.localizable.top_polls())
        }

        categoriesSection.onSelection = { [weak self] category in
            guard let self = self else {
                return
            }
            self.output?.openList(type: .fromCategory(categoryId: Int(category.id)), title: category.label)
        }
        topCreatorsSection.onSelection = { [weak self] userStoryData in
            self?.output?.openUserProfile(storyData: userStoryData)
        }
        topCreatorsSection.onStorySelection = { [weak self] userStoryData in
            self?.output?.openStories(storyData: userStoryData)
        }
    }
}
