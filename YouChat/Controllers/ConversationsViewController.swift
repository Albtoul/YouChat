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
    
    var conversations : [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeTapped))
        tableView.dataSource = self
        tableView.delegate = self
        
        startListenToConversations()
        
        // Do any additional setup after loading the view.
    }
    
    func startListenToConversations(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(of: email)
        
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: {
            [weak self] result in
            switch result {
            case .success(let convos):
                self?.conversations = convos
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
        vc.isNewConversation = true
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
        conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = conversations[indexPath.row].name
        cell.detailTextLabel?.text = conversations[indexPath.row].latest_Message.text
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let convo = conversations[indexPath.row]
        let vc = ChatViewController(with: convo.other_user_email , id: convo.id)
        vc.title = convo.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
