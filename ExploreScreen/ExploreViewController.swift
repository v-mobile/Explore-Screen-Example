//
//  ExploreViewController.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright (c) 2021 V-Mobile. All rights reserved.
//

import UIKit
import shared
import XSRefresh

protocol ExploreViewControllerOutput: AnyObject {
    func openProfile()
}

final class ExploreViewController: UIViewController {

    var viewModel: ExploreViewModelType!
    var mainView: ExploreView {
        // swiftlint:disable force_cast
        return view as! ExploreView
        // swiftlint:enable force_cast
    }
    weak var output: ExploreViewControllerOutput?
    weak var coordinator: HomeContainerCoordinator?
    let notificationService = NotificationService()

    // MARK: - View lifecycle
    override func loadView() {
        let mainView = ExploreView(frame: .zero)
        mainView.output = self
        mainView.scrollView.xs.header = XSRefreshNormalHeader { [weak self] in
            self?.getData()
        }
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        handleNotifications()
    }

    func initialize() {
        viewModel.output.subscriber = self
        navigationItem.title = R.string.localizable.explore()
        getData()
    }

    func getData() {
        mainView.categoriesSection.collectionView.showAnimatedSkeleton()
        mainView.topCreatorsSection.collectionView.showAnimatedSkeleton()
        mainView.topPollsSection.collectionView.showAnimatedSkeleton()
        viewModel.input.getCategories()
        viewModel.input.getTopPolls()
        viewModel.input.getTopCreators()
    }

    func handleNotifications() {
        notificationService.observe(type: .voteOnStory) { [weak self] (data: StoryVoteData) in
            self?.viewModel.input.pick(data: data)
            self?.mainView.topCreatorsSection.collectionView.reloadData()
        }
        notificationService.observe(type: .storySeen) { [weak self] (data: StorySeenData) in
            self?.viewModel.input.getSnapDetail(data: data)
            self?.mainView.topCreatorsSection.collectionView.reloadData()
        }
    }
}

extension ExploreViewController: ExploreViewModelOutputSubscriber {

    func gotCategories() {
        mainView.categoriesSection.categories = viewModel.output.categories
        checkState()
    }

    func gotPolls() {
        mainView.topPollsSection.polls = viewModel.output.polls
        checkState()
    }

    func gotCreators() {
        mainView.topCreatorsSection.creators = viewModel.output.creators
        checkState()
    }

    private func checkState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            if !mainView.topPollsSection.collectionView.isSkeletonActive
                && !mainView.topCreatorsSection.collectionView.isSkeletonActive
                && !mainView.categoriesSection.collectionView.isSkeletonActive {
                mainView.scrollView.xs.header?.endRefreshing()
            }
        }
    }
}

extension ExploreViewController: ExploreViewOutput {

    func openList(type: ExploreListType, title: String) {
        let repo: AuthRepo = Resolver.resolve()
        if repo.isSignIn() {
            openExploreList(type: type, title: title)
        } else {
            coordinator?.openGetStartedScreen { [weak self] in
                self?.openExploreList(type: type, title: title)
            }
        }
    }

    func openStories(storyData: UserStoryData) {
        let igData = storyData.toIGData()
        openStories(stories: [igData], selectedStoryIndex: 0,
                    selectedSnapIndex: storyData.selectedStoryIndex)
    }

    func openUserProfile(storyData: UserStoryData) {
        if storyData.isCurrentUser {
            output?.openProfile()
        } else {
            openProfile(userId: Int(storyData.userId) ?? 0)
        }
    }

    private func openExploreList(type: ExploreListType, title: String) {
        let controller = ViewControllerModule.getExploreListViewController(type: type, title: title)
        let navController = homeNavigationController
        navController.pushViewController(controller, animated: false)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
