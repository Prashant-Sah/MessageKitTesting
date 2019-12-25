//
//  BaseController.swift
//  Finkey
//
//  Created by Narendra Bdr Kathayat on 10/14/19.
//  Copyright © 2019 EBPearls. All rights reserved.
//

import UIKit
import RxSwift

typealias AlertHandler = ((UIAlertAction) -> Swift.Void)?

/// The base controller for all controllers
class BaseController: UIViewController {
    
    let baseView: BaseView
    let baseViewModel: BaseViewModel

    /// The backbutton that we will display on navigation bar
    private lazy var backButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "eye-off"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(back))
        item.imageInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        item.tintColor = .white
        return item
    }()
    
    init(baseView: BaseView, viewModel: BaseViewModel) {
        self.baseView = baseView
        self.baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Checks if the controller was presented modally or not
    private var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    lazy var isRoot: Bool = {
        if let viewControllers = self.navigationController?.viewControllers {
            return viewControllers.count == 1
        } else {
            return true
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = backButton
        
        //app setting up the  UI
        setupUI()
        
        //binding the controls
        bindControls()
        
        //observe the events triggered
        observeEvents()
    }
    
    override func loadView() {
        super.loadView()
        //view = baseView
        view.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseView.topAnchor.constraint(equalTo: view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Base function 
    func setupUI() {}
    func bindControls() {}
    func observeEvents() {}
    
    @objc func back() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Deinit
    deinit {
        print("De-Initialized -- \(String(describing: self))")
    }
}

// MARK: - Action Handler
extension BaseController {
    
    /// Popup alert with message
    ///
    /// - Parameters:
    ///   - message: message
    func popAlert(with message: String) {
        alertActionHandler(with: message, firstAction: "OK", firstHandler: nil, secondAction: "", secondHandler: nil)
    }
    
    /// Popup alert with action handler
    ///
    /// - Parameters:
    ///   - message: message
    ///   - okTitle: action title
    ///   - handler: action handler
    func alertWithOkHandler(message: String, okTitle: String = "OK", handler: AlertHandler) {
        alertActionHandler(with: message, firstAction: okTitle, firstHandler: handler, secondAction: "", secondHandler: nil)
    }
    
    /// Show Alert Controller
    ///
    /// - Parameters:
    ///   - message: message
    ///   - firstAction: first action title
    ///   - firstHandler: first  action handler
    ///   - secondAction: second action title
    ///   - secondHandler: second  action handler
    func alertActionHandler(with message: String, firstAction: String, firstHandler: AlertHandler, secondAction: String, secondHandler: AlertHandler) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: firstAction, style: .default, handler: firstHandler)
        
        if !secondAction.isEmpty {
            let secondAction = UIAlertAction(title: secondAction, style: .default, handler: secondHandler)
            alert.addAction(secondAction)
        }
        alert.addAction(firstAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func inProgressPopUp() {
        popAlert(with: "In Progress...")
    }
}
