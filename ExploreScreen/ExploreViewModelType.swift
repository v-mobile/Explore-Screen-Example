//
//  ExploreViewModelType.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright (c) 2021 V-Mobile. All rights reserved.
//

import Foundation

protocol ExploreViewModelOutputSubscriber: AnyObject {
    func gotCategories()
    func gotPolls()
    func gotCreators()
}

protocol ExploreViewModelOutput: AnyObject {
    var subscriber: ExploreViewModelOutputSubscriber? { get set }
    var categories: [Category] {get}
    var polls: [PollData] {get}
    var creators: [UserStoryData] {get}
}

protocol ExploreViewModelInput: AnyObject {
    func getCategories()
    func getTopPolls()
    func getTopCreators()
    func pick(data: StoryVoteData)
    func getSnapDetail(data: StorySeenData)
}

protocol ExploreViewModelType: AnyObject {
    var input: ExploreViewModelInput { get }
    var output: ExploreViewModelOutput { get }
}

extension ExploreViewModelType where Self: ExploreViewModelInput, Self: ExploreViewModelOutput {
    var input: ExploreViewModelInput { return self }
    var output: ExploreViewModelOutput { return self }
}
