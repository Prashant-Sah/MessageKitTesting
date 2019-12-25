//
//  ChatController.swift
//  Dragonfly
//
//  Created by ebpearls on 2019/12/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import UIKit
import MessageKit

class ChatController: BaseController {

    lazy var chatView: ChatView = {
        return baseView as! ChatView
    }()

    lazy var viewModel: ChatViewModel = {
        return baseViewModel as! ChatViewModel
    }()

    var messageList = [MockMessage]()
    let messageController = MainChatController()

    public let refreshControl = UIRefreshControl()

    /// Required for the MessageInputBar to be visible
    override var canBecomeFirstResponder: Bool {
      return messageController.canBecomeFirstResponder // must be true
    }

    /// Required for the MessageInputBar to be visible
    override var inputAccessoryView: UIView? {
      return messageController.inputAccessoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupNav()
        observeEvents()
        addMessageController()
    }

    func setupNav() {
        title = "#Order 123456"
        navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "eye-off")
        navigationItem.backBarButtonItem?.imageInsets =  UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "eye-off"), style: .plain, target: self, action: nil)
        navigationController?.isNavigationBarHidden = false
    }

    func addMessageController() {
        messageController.willMove(toParent: self)
        addChild(messageController)
        chatView.addSubview(messageController.view)
        messageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageController.view.leadingAnchor.constraint(equalTo: chatView.leadingAnchor),
            messageController.view.topAnchor.constraint(equalTo: chatView.chatTopView.bottomAnchor),
            messageController.view.trailingAnchor.constraint(equalTo: chatView.trailingAnchor),
            messageController.view.bottomAnchor.constraint(equalTo: chatView.bottomAnchor, constant: 0)
        ])
        messageController.didMove(toParent: self)
    }

    override func observeEvents() {

        chatView.textMessageView.sendButton.rx.tap.asDriver().drive(onNext: { [weak self] (_) in
            guard let self = self else { return }
//            let text = self.chatView.textMessageView.textView.text.trimmingCharacters(in: .whitespaces)
//            guard !text.isEmpty else { return }
//            self.viewModel.sendMessage(msg: text)
//            self.chatView.textMessageView.textView.text = ""
        }).disposed(by: viewModel.bag)

//        viewModel.messages.bind(to: chatView.tableView.rx.items(cellIdentifier: MessageCell.identifier, cellType: MessageCell.self)) { row, item, cell in
//            cell.textLabel?.numberOfLines = 0
//            cell.textLabel?.text = item
//        }.disposed(by: viewModel.bag)
    }

}
