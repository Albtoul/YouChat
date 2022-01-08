//
//  RegisterViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameField:UITextField!
    @IBOutlet weak var lastNameField:UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var profileImage:UIImageView!
    
    let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        roundedCorner()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGR)
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            presentPhotoActionSheet()
        }
    }
    
    @IBAction func registerButtonPressed(_ sender:UIButton){
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty,
              password.count >= 6, let imageData = profileImage.image?.pngData() else {
            return
        }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.userExists(with: email, completion: {
            exsist in
            
            guard !exsist else {
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self]
                _, error in
                
                guard error == nil else {
                    print("Error : \(String(describing: error?.localizedDescription))")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                
                let user = ChatUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: user, completion: {
                    success in
                    if success {
                        StorageManager.shared.uploadProfilePicture(with: imageData, fileName: user.profileImageName, completion: {
                            result in
                            switch result{
                            case .success(let url):
                                print(url)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                    }
                })
                
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}

extension RegisterViewController {
    func roundedCorner(){
        
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.masksToBounds = true
        
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.masksToBounds = true
        
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.masksToBounds = true
        
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // get results of user taking picture or selecting from camera roll
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // take a photo or select a photo
        
        // action sheet - take photo or choose photo
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profileImage.image = selectedImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


