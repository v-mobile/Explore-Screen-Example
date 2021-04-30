//
//  TopStoriesImageAdapter.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit

class TopPollsImageAdapter {

    func configure(cell: TopPollsViewCell,
                   item: PollData) {
        cell.showImagePoll()
        cell.imagePollContainerView.setDefault()
        let firstOption = cell.imagePollContainerView.firstOptionView
        let secondOption = cell.imagePollContainerView.secondOptionView
        firstOption.setup(data: item.firstItemData?.data)
        secondOption.setup(data: item.secondItemData?.data)
        firstOption.infoSectionContainer.isHidden = true
        secondOption.infoSectionContainer.isHidden = true
        firstOption.isClickable = false
        secondOption.isClickable = false
        cell.imagePollContainerView.set(for: item.direction)
        cell.imagePollContainerView.spacing = 8
        if item.direction == .horizontal {
            cell.imagePollContainerView.directionalLayoutMargins = .init(top: 0, leading: 32, bottom: 0, trailing: 32)
        } else {
            cell.imagePollContainerView.directionalLayoutMargins = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        }
    }
}
