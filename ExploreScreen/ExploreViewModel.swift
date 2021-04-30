//
//  ExploreViewModel.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright (c) 2021 V-Mobile. All rights reserved.
//

import UIKit
import shared

final class ExploreViewModel: ExploreViewModelType, ExploreViewModelOutput {
    weak var subscriber: ExploreViewModelOutputSubscriber?
    private let repo: CategoryRepo = Resolver.resolve()
    private let exploreRepo: ExploreRepo = Resolver.resolve()
    private(set) var categories: [Category] = []
    private(set) var polls: [PollData] = []
    private(set) var creators: [UserStoryData] = []

    let service = NotificationService()

    init() {
        service.observe(type: .login) { [weak self] (_: Int?) in
            self?.getTopPolls()
            self?.subscriber?.gotCreators()
        }
        service.observe(type: .voteOnPoll) { [weak self] (type: VotedType) in
            switch type {
            case .explore(let pollId), .feed(let pollId), .otherUser(let pollId):
                if self?.polls.contains(where: {$0.pollId == Int(pollId)}) ?? false {
                    self?.getTopPolls()
                }
            }
        }
    }
}

extension ExploreViewModel: RequestActivityHandler {
    var handler: UIViewController? {
        return subscriber as? UIViewController
    }
}

extension ExploreViewModel: ExploreViewModelInput {

    func getTopPolls() {
        exploreRepo.getTopPolls(data: TopPollRequestData(limit: 3, forceRefresh: true),
                                completionHandler: responseHandler(onSuccess: { [weak self] (polls: [ActivePoll]) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.polls = polls.map({$0.toActivePollData()})
            strongSelf.subscriber?.gotPolls()
        }, onComplete: { [weak self] in
            self?.stopLoading()
            self?.subscriber?.gotPolls()
        }))
    }

    func getTopCreators() {
        exploreRepo.getTopCreators(completionHandler: responseHandler(onSuccess: { [weak self] (stories: [UserStory]) in
            self?.creators = stories.map({$0.toUserStoryData()})
            self?.subscriber?.gotCreators()
        }, onComplete: { [weak self] in
            self?.subscriber?.gotCreators()
        }))
    }

    func getCategories() {
        exploreRepo.getTopCategories(completionHandler:
                                        responseHandler(onSuccess: { [weak self] (categories: [Category]) in
            self?.categories = categories
            self?.subscriber?.gotCategories()
        }, onComplete: { [weak self] in
            self?.subscriber?.gotCategories()
        }))
    }

    func pick(data: StoryVoteData) {
        let currentStory = creators.first(where: {$0.userId == data.userId})
        let snap = currentStory?.stories.first(where: {$0.storyId == data.snapId})
        if snap?.option.leftOption.storyId?.description == data.optionId.description {
            snap?.option.leftOption.votes += 1
        } else {
            snap?.option.rightOption.votes += 1
        }
        snap?.isVoted = true
    }

    func getSnapDetail(data: StorySeenData) {
        let currentStory = creators.first(where: {$0.userId == data.userId})
        currentStory?.lastSeenStoryId = data.snapId
    }
}
