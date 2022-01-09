//
//  ConversationsViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeTapped))
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func composeTapped(){
        let vc = storyboard?.instantiateViewController(identifier: "NewConversationVC") as! NewConversationViewController
        vc.completion = {
            [weak self] result in
            self?.createConv(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    func createConv(result:[String:String]){
        guard let name=result["name"], let email = result["email"] else {
            print(result)
            return
        }
        let vc = ChatViewController(with: email, id: nil)
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    func validateAuth(){
        if Auth.auth().currentUser == nil {
            let loginVC = storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.modalPresentationStyle = .fullScreen
            self.present(loginNav, animated: false, completion: nil)
        }
    }
}

extension ConversationsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(with: "", id: nil)
        vc.title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
