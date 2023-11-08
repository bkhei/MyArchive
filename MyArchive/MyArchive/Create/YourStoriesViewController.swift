//
//  YourStoriesViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class YourStoriesViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    // Stories array, will be initialized in query function
    private var stories = [Story]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
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
         Getting stories created by the current user
         */
        // Queries Story instances, explicitly including the user property and sorted
        let query = Story.query().include("user").order([.descending("createdAt")]).where("user" == User.current?.username)
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

}
extension YourStoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourStoryCell", for: indexPath) as? YourStoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: stories[indexPath.row])
        return cell
    }
    
    
}
