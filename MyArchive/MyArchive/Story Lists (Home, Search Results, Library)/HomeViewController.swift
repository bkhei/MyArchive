//
//  HomeViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//
//  NEEDS TESTING

import UIKit
import ParseSwift

class HomeViewController: UIViewController {
    // Table View Outlet
    @IBOutlet weak var tableView: UITableView!
    // Refresh control for pull-to-refresh functionality
    private let refreshControl = UIRefreshControl()
    // Stories array, will be initialized in query function
    private var stories = [Story]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view data source
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        print("Home view loaded!")
    }
    @IBAction func onLogoutTapped(_ sender: Any) {
        confirmLogoutAlert()
    }
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryStories {
            [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryStories()
    }
    private func queryStories(completion: (() -> Void)? = nil) {
        /*
         Creating a query to fetch stories
         Properties that are parse objects (User in this case) stored by reference in Parse DB, so need to be explicityly included
         Sorting stories in descending order based on creation date
         Getting stories where isPublished is true
         */
        // Queries Story instances, explicitly including the user property and sorted
        let query = Story.query().include("user").order([.descending("createdAt")]).where("isPublished" == true)
        // Finding and returning the stories
        query.find {
            [weak self] result in
            switch result {
            case .success(let stories):
                // Updating the local stories property with the fetched stories
                self?.stories = stories
            case .failure(let error):
                print("Fetch failed: \(error)")
            }
            // Completion handler, used to tell pull-to-refresh control to stop refreshing
            completion?()
        }
    }
    
    // Prepare for segue and send data to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let DVC = segue.destination as? DetailViewController {
            let tappedStory = stories[indexPath.row]
            DVC.story = tappedStory
        }
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

// Conforming view controller to UITableViewDataSource -- INCOMPLETE
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as? StoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: stories[indexPath.row])
        return cell
    }
    
    
}

