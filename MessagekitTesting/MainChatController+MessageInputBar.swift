//
//  ChatController+MessageInputBar.swift
//  Dragonfly
//
//  Created by ebpearls on 2019/12/23.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import Foundation
import MessageKit
import InputBarAccessoryView

extension MainChatController {

    func configureMessageInputBar() {

        // set delegate
        messageInputBar.delegate = self

        // set textview height limit
        messageInputBar.shouldAutoUpdateMaxTextViewHeight = false
        messageInputBar.maxTextViewHeight = 80

        // set separator line hidden
        messageInputBar.separatorLine.isHidden = true

        // configure placeholder and textcolor
        messageInputBar.inputTextView.placeholderTextColor = .purple
        messageInputBar.inputTextView.textColor = .purple
        messageInputBar.inputTextView.placeholderLabel.text = "Your Message"

        let cameraButton = InputBarButtonItem().configure {
            $0.setSize(CGSize(width: 52, height: 30), animated: false)
            $0.isEnabled = true
            $0.image = #imageLiteral(resourceName: "eye-off").withRenderingMode(.alwaysTemplate)
            $0.imageEdgeInsets.left = 14
            $0.imageEdgeInsets.top = 6
            $0.tintColor = .purple
        }.onTouchUpInside { [unowned self] _ in
            print("touched")
        }.onTextViewDidChange({  (_, _) in

        })

        let sendButton = InputBarButtonItem().configure {
            $0.setSize(CGSize(width: 52, height: 30), animated: false)
            $0.isEnabled = true
            $0.image = #imageLiteral(resourceName: "eye-off")
            $0.tintColor = .purple
//            $0.imageEdgeInsets.left = 14
//            $0.imageEdgeInsets.top = 6
            $0.transform = CGAffineTransform(rotationAngle: -.pi/2)
        }.onTouchUpInside { [unowned self] _ in
            self.messageInputBar.didSelectSendButton()
        }.onTextViewDidChange({  (_, _) in

        })

        messageInputBar.setLeftStackViewWidthConstant(to: 52, animated: false)
        messageInputBar.setStackViewItems([cameraButton], forStack: .left, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 52, animated: false)
        messageInputBar.setStackViewItems([sendButton], forStack: .right, animated: false)

        // contentView border
        messageInputBar.contentView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.contentView.layer.borderWidth = 1
        messageInputBar.contentView.layer.cornerRadius = 6
        messageInputBar.contentView.layer.masksToBounds = true

        messageInputBar.padding = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 34)

        messageInputBar.middleContentViewPadding = UIEdgeInsets(top: 22, left: 0, bottom: 22, right: 0)

        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 8)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 8)
    }


    private func openGalleryController() {
        
    }

}

extension MainChatController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Your Message"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }

}

