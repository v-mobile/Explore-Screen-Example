//
//  TopStoriesTextAdapter.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit

class TopPollsTextAdapter {

    func configure(cell: TopPollsViewCell,
                   item: PollData) {
        cell.showTextPoll()
        cell.textPollContainerView.setDefault()
        let firstOption = cell.textPollContainerView.firstOptionView
        let secondOption = cell.textPollContainerView.secondOptionView
        firstOption.isClickable = false
        secondOption.isClickable = false
        firstOption.setup(data: item.firstItemData?.data)
        secondOption.setup(data: item.secondItemData?.data)
        cell.textPollContainerView.spacing = 8
        if item.direction == .horizontal {
            cell.textPollContainerView.directionalLayoutMargins = .init(top: 0, leading: 32, bottom: 0, trailing: 32)
        } else {
            cell.textPollContainerView.directionalLayoutMargins = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        }
    }
}
