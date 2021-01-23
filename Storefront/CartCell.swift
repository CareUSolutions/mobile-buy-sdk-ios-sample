//
//  CartCell.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit

protocol CartCellDelegate: class {
    func cartCell(_ cell: CartCell, didUpdateQuantity quantity: Int)
}

class CartCell: UITableViewCell, ViewModelConfigurable, UITextFieldDelegate {
    
    typealias ViewModelType = CartItemViewModel
    
    weak var delegate: CartCellDelegate?

    @IBOutlet private weak var thumbnailView: UIImageView!
    @IBOutlet private weak var titleLabel:    UILabel!
    @IBOutlet private weak var priceLabel:    UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var stepper:       UIStepper!
    @IBOutlet weak var inputField: UITextField!
    
    
    
    var viewModel: ViewModelType?
    
    // ----------------------------------
    //  MARK: - Configure -
    //
    func configureFrom(_ viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        self.titleLabel.text    = viewModel.title
        self.priceLabel.text    = viewModel.price
        self.quantityLabel.text = viewModel.quantityDescription
        self.stepper.value      = Double(viewModel.quantity)
        self.stepper.autorepeat = true
        self.stepper.minimumValue = 0
        self.thumbnailView.setImageFrom(viewModel.imageURL)
        self.inputField.text = String(Double(viewModel.quantity))
        
        inputField.delegate = self;
    }
}

// ----------------------------------
//  MARK: - Actions -
//
extension CartCell {
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        self.delegate?.cartCell(self, didUpdateQuantity: Int(sender.value))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @IBAction func inputChanged(_ sender: UITextField) {
        
    }
    
}
