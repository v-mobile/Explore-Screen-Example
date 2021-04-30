//
//  TopCreatorsAdapter.swift
//  dzain
//
//  Created by Narek Simonyan on 21.01.21.
//  Copyright © 2021 V-Mobile. All rights reserved.
//

import UIKit
import SDWebImage

class TopCreatorsAdapter {

    func configure(cell: TopCreatorsViewCell, item: UserStoryData) {
        DispatchQueue.main.async {
            cell.layoutIfNeeded()
            cell.nameLabel.text = item.username
            let shouldDisableStories = item.stories.isEmpty || item.isCurrentUser
            if shouldDisableStories {
                cell.profileView.layerView.colors = []
            } else
            if item.isAllSeen {
                cell.profileView.layerView.colors = [
                    R.color.allSeenStoryColor()!,
                    R.color.allSeenStoryColor()!,
                    R.color.allSeenStoryColor()!
                ]
            } else {
                cell.profileView.layerView.colors = [currentTheme
                                                        .primaryActionBackgroundColor,
                                                     currentTheme.gradientMiddleColor,
                                                     currentTheme.gradientEndColor]
            }
            cell.profileView.isUserInteractionEnabled = !shouldDisableStories
            cell.profileView.imageView.sd_setImage(with: URL(string: item.profileImageUrl),
                                                   placeholderImage: R.image.userPlaceholder())
        }
    }
}
