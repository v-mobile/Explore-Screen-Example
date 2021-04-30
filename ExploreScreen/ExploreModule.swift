//
//  ExploreModule.swift
//  dzain
//
//  Created by Narek Simonyan on 19.01.21.
//  Copyright (c) 2021 V-Mobile. All rights reserved.
//

import UIKit

extension ViewControllerModule {
    static func getExploreViewController() -> ExploreViewController {
        let controller = ExploreViewController()
        controller.viewModel = ViewModelModule.getExploreViewModel()
        return controller
    }
}

extension ViewModelModule {
    static func getExploreViewModel() -> ExploreViewModelType {
        return ExploreViewModel()
    }
}
