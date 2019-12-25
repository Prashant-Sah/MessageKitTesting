//
//  BaseView.swift
//  Finkey
//
//  Created by Manjil on 10/22/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import UIKit


class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }

    /// The containerViow to display scrolling content
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func create() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
    }
}
