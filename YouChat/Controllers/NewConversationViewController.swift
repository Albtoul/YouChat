//
//  NewConversationViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    var completion : (([String:String]) -> (Void))?
    
    var users : [[String:String]] = []
    var results : [[String:String]] = []
    var hasFetched = false

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users.."
        return searchBar
    }()
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPressed))
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }

}

extension NewConversationViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = results[indexPath.row]["name"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targeUser = results[indexPath.row]
        dismiss(animated: true, completion: {
            [weak self] in
            self?.completion?(targeUser)
        })
    }
    
    
}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchUsers(query: text)
    }
    
    func searchUsers(query:String){
        if hasFetched {
            filterUsers(term: query)
        }else {
            DatabaseManager.shared.getAllUsers(completion: {
                [weak self] result in
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.hasFetched = true
                    self?.filterUsers(term: query)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func filterUsers(term:String){
        guard hasFetched else {
            return
        }
        
        let results =  self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        tableView.reloadData()
    }
}
