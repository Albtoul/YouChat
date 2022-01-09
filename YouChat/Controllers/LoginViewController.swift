//
//  LoginViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(registerPressed))
        roundedCorner()
        // Do any additional setup after loading the view.
    }
    
    @objc func registerPressed(){
        let registerVC = storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton){
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty, !password.isEmpty else {
            return
        }
        
        spinner.show(in: view)
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            [weak self] _, error in
            
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
            guard error == nil else {
                print("Error : \(String(describing: error?.localizedDescription))")
                return
            }
            
            
            
            DatabaseManager.shared.getUserData(for: email, completion: {
                result in
                switch result{
                case .success(let userData):
                    guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                        return
                    }
                    
                    UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            
            UserDefaults.standard.setValue(email, forKey: "email")
            
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
}

extension LoginViewController {
    func roundedCorner(){
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.masksToBounds = true
        
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.masksToBounds = true
        
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        
    }
}
