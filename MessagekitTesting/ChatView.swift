//
//  ChatView.swift
//  Dragonfly
//
//  Created by ebpearls on 2019/12/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import Foundation
import MessageKit
import UIKit

class Separator: BaseView {

    override func create() {
        setupView()
    }

    func setupView() {
        backgroundColor = .lightText
    }
}

class ChatTopView: BaseView {

    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Samuel Jones"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var callButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "eye-off"), for: .normal)
        return button
    }()

    lazy var separator: Separator = {
        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()

   override func create() {
       self.generateChildrens()
   }

    func generateChildrens() {

        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34),
            userNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34)
        ])

        addSubview(callButton)
        NSLayoutConstraint.activate([
            callButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            callButton.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 8),
            callButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34),
            callButton.heightAnchor.constraint(equalToConstant: 40),
            callButton.widthAnchor.constraint(equalToConstant: 40)
        ])

        addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

}

class TextMessageView: BaseView, UITextViewDelegate {

    let textViewMaxHeight = CGFloat(80)

    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "eye-off"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .darkText
        textView.textContainerInset = .zero
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "eye-off"), for: .normal)
        button.transform = CGAffineTransform(rotationAngle: -.pi/2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func create() {
        generateChildrens()
    }

    func generateChildrens() {

        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightText.cgColor
        layer.borderWidth = 1

        addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            cameraButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            cameraButton.widthAnchor.constraint(equalToConstant: 35),
            cameraButton.heightAnchor.constraint(equalToConstant: 28)
        ])

        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 6),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: textViewMaxHeight)
        ])

        textView.delegate = self

        addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 12),
            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -22),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        guard size.height != newSize.height else { return }

        if newSize.height >= textViewMaxHeight {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
    }

}

class MessageCell: UITableViewCell {}

class ChatView: BaseView {

    lazy var chatTopView: ChatTopView = {
        let topChatView = ChatTopView()
        topChatView.translatesAutoresizingMaskIntoConstraints = false
        return topChatView
    }()

    lazy var textMessageView: TextMessageView = {
        let textMessageView = TextMessageView()
        textMessageView.translatesAutoresizingMaskIntoConstraints = false
        return textMessageView
    }()

    lazy var chatContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.separatorStyle = .none
//        tableView.registerClass(MessageCell.self)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()

    lazy var collectionView: MessagesCollectionView = {
        let collectionView = MessagesCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 24)
        return collectionView
    }()

    override func create() {
        generateChildrens()
    }

    func generateChildrens() {

        backgroundColor = .purple

        addSubview(chatContainer)
        NSLayoutConstraint.activate([
            chatContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            chatContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            chatContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            chatContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        chatContainer.addSubview(chatTopView)
        NSLayoutConstraint.activate([
            chatTopView.topAnchor.constraint(equalTo: chatContainer.topAnchor),
            chatTopView.leadingAnchor.constraint(equalTo: chatContainer.leadingAnchor),
            chatTopView.trailingAnchor.constraint(equalTo: chatContainer.trailingAnchor)
        ])

        chatContainer.addSubview(textMessageView)
        NSLayoutConstraint.activate([
            textMessageView.bottomAnchor.constraint(equalTo: chatContainer.bottomAnchor, constant: -16),
            textMessageView.leadingAnchor.constraint(equalTo: chatContainer.leadingAnchor, constant: 34),
            textMessageView.trailingAnchor.constraint(equalTo: chatContainer.trailingAnchor, constant: -34)
        ])

        chatContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: chatTopView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: textMessageView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: chatContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: chatContainer.trailingAnchor)
        ])
    }
}


