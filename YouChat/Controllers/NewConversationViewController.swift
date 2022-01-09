//
//  NewConversationViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit

class NewConversationViewController: UIViewController {

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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    
}

extension NewConversationViewController : UISearchBarDelegate {
    
}
