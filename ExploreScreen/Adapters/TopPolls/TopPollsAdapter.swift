//
//  TopStoriesAdapter.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import Foundation

class TopPollsAdapter {

    let imageAdapter = TopPollsImageAdapter()
    let textAdapter = TopPollsTextAdapter()
    
    func configure(cell: TopPollsViewCell,
                   item: PollData) {
        if item.type == .gif || item.type == .image {
            imageAdapter.configure(cell: cell, item: item)
        } else {
            textAdapter.configure(cell: cell, item: item)
        }
        if item.direction == .horizontal {
            cell.footerView.directionalLayoutMargins = .init(top: 0, leading: 32, bottom: 0, trailing: 32)
        } else {
            cell.footerView.directionalLayoutMargins = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        }
        configureHeader(cell: cell, item: item)
        configureFooter(cell: cell, item: item)
    }

    func configureHeader(cell: TopPollsViewCell,
                         item: PollData) {
        cell.headerView.profileView.isHidden = true
        cell.headerView.optionView.isHidden = true
        cell.headerView.titleLabel.text = item.title
        cell.headerView.profileView.userInfo = .profile(userId: item.userId)
    }

    func configureFooter(cell: TopPollsViewCell,
                         item: PollData) {
        cell.footerView.votersLabel.text = R.string.localizable.total_votes(item.totalVotes.description)
        if item.isEnded {
            cell.footerView.daysLabel.text = R.string.localizable.completed()
        } else {
            cell.footerView.daysLabel.text = item.dateDifference
        }
    }
}
