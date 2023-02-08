//
//  ProductTableViewCell.swift
//  CabifyTest
//
//  Created by Pedro Moura on 03/02/23.
//

import UIKit
import Combine

class ProductTableViewCell: UITableViewCell {
    private var viewModel: ProductTableViewCellViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var priceLabel = makePriceLabel()
    private lazy var quantityStepperView = makeStepperView()
    private lazy var quantityLabel = makeQuantityLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension ProductTableViewCell {
    func setupView() {
        // TODO: Review this layout
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityStepperView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            quantityStepperView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            quantityStepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quantityLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 4),
            quantityLabel.trailingAnchor.constraint(equalTo: quantityStepperView.leadingAnchor, constant: -24)
        ])
    }
    
    func setupBindings() {
        viewModel?.product
            .sink(receiveValue: { [weak self] product in
                self?.titleLabel.text = product.name
                self?.priceLabel.text = "$\(product.price)"
            })
            .store(in: &cancelBag)
    }
}

// MARK: - Setup UI Elements

extension ProductTableViewCell {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeQuantityLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }
    
    func makeStepperView() -> UIStepper {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }
}

// MARK: - Actions

extension ProductTableViewCell {
    @objc func stepperValueChanged(_ sender: UIStepper) {
        // TODO: Rethink how the label gets the value
        quantityLabel.text = "\(Int(sender.value))"
        viewModel?.productOperation(.addProduct(product: (viewModel?.product.value)!))
    }
}

// MARK: - Render

extension ProductTableViewCell {
    func render(viewModel: ProductTableViewCellViewModel) {
        guard viewModel !== self.viewModel else { return }
        self.viewModel = viewModel
        
        cancelBag = Set<AnyCancellable>()
        setupBindings()
    }
}
