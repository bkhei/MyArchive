//
//  HomeViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class HomeViewController: UIViewController {
    // Table View Outlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view data source
        //tableView.dataSource = self
        print("Home view loaded!")
    }
    @IBAction func onLogoutTapped(_ sender: Any) {
        confirmLogoutAlert()
    }
    
}
// Helper methods
extension HomeViewController {
    private func confirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) {
            _ in
            // Posting logout notification
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
/*
// Conforming view controller to UITableViewDataSource -- INCOMPLETE
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
*/
