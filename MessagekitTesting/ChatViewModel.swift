//
//  ChatViewModel.swift
//  Dragonfly
//
//  Created by ebpearls on 2019/12/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class ChatViewModel: BaseViewModel {

    let messages = BehaviorRelay(value: [String]())
    private let batchSize = 20

    ///the number of message that are not shown in the view.
    ///it will be used to determine the offset for the message
    private var remainingMessageCount = 0

    override init() {
        super.init()
    }

}
