//
//  CheckoutViewController.swift
//  CabifyTest
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    private let viewModel: CheckoutViewModel
    
    required init(viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
