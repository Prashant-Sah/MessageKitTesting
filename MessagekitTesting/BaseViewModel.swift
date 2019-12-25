//
//  BaseViewModel.swift
//  Finkey
//
//  Created by Narendra Bdr Kathayat on 10/14/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import Foundation
import RxSwift

/// The base viewModel for all viewModels
class BaseViewModel {

    /// The routes trigger
    /// The disposable bag for the viewModel
    var bag: DisposeBag = DisposeBag()
    
    /// de-init
    deinit {
        print("De-Initialized -- \(String(describing: self))")
    }
}
