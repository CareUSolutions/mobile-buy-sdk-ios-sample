//
//  SignupViewController.swift
//  Storefront
//
//  Created by Zheng on 2/3/21.
//  Copyright © 2021 Shopify Inc. All rights reserved.
//

import UIKit
import Buy

class SignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    private let client: Graph.Client = Graph.Client(shopDomain: Client.shopDomain, apiKey: Client.apiKey, locale: Client.locale)
    
    private var email: String {
        return self.emailField.text ?? ""
    }
    
    private var password: String {
        return self.passwordField.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateSignupState()
    }
    
    private func updateSignupState() {
        let isValid = !self.email.isEmpty && !self.password.isEmpty
        print(isValid)
        self.signupButton.isEnabled = isValid
        self.signupButton.alpha = isValid ? 1.0 : 0.5
    }
    
   
    
}

extension SignupViewController {
    @IBAction func textEditChanged(_ sender: UITextField) {
        self.updateSignupState()
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        let input = Storefront.CustomerCreateInput.create(
            email:         email,
            password:      password
        )

        let mutation = Storefront.buildMutation { $0
            .customerCreate(input: input) { $0
                .customer { $0
                    .id()
                    .email()
                    .firstName()
                    .lastName()
                }
                .customerUserErrors { $0
                    .field()
                    .message()
                }
            }
        }

        let task = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let mutation = response?.customerCreate {
                if let _ = mutation.customer, !mutation.customerUserErrors.isEmpty {
                    print("customer created!")
                } else {
                    mutation.customerUserErrors.forEach {
                        let fieldPath = $0.field?.joined() ?? ""
                            print("  \(fieldPath): \($0.message)")
                        // password too short
                        if $0.message.contains("Password is too short") {
                            let dialogMessage = UIAlertController(title: "Password is too short!", message: "Please enter a password longer than 5 characters!", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                             })
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)

                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                        }
                        
                        // invalid email
                        if $0.message.contains("Email is invalid") {
                            let dialogMessage = UIAlertController(title: "Email is invalid!", message: "Please enter a valid email address!", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                             })
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)

                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                        }
                    }
                    print(mutation.customerUserErrors)
                }
            } else {
                print("fail to create a customer...")
            }
        }
        task.resume()
    }
}
