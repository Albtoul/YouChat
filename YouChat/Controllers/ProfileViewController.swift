//
//  ProfileViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureView()
    }
    
    func configureView(){
        guard let name = UserDefaults.standard.value(forKey: "name") as? String, let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(of: email)
        
        StorageManager.shared.downloadURL(for: "images/\(safeEmail)_profile_picture.png", completion: {
            [weak self] result in
            switch result{
            case .success(let url):
                DispatchQueue.main.async {
                    self?.profileImage.sd_setImage(with: url)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        nameLabel.text = name
        
        
    }
    
    @IBAction func signOut(){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")
        }catch{
            print(error.localizedDescription)
        }
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
        tabBarController?.present(loginNav, animated: true, completion: {
            [weak self] in
            self?.tabBarController?.selectedIndex = 0
        })
    }

}
