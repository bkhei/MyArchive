//
//  SearchResultViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class SearchResultViewController: UIViewController {
    // story property
    private var stories = [Story]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }
    // Search property -- category or string user used to search/filter
    var searchTitle: String?
    var searchGenre: String?
    // table view outlet
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view data source
        tableView.dataSource = self
        print("Search Results Loaded!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryStories()
    }
    
    private func queryStories(completion: (() -> Void)? = nil) {
        if let st = searchTitle {
            // Searching by title
            // Queries Story instances, explicitly including the user property, chapters, and sorted
            let query = Story.query(containsString(key: "title", substring: st)).include("user").include("chapters").order([.descending("createdAt")]).where("isPublished" == true)
            // Finding and returning the stories
            query.find {
                [weak self] result in
                switch result {
                case .success(let stories):
                    // Updating the local stories property with the fetched stories
                    self?.stories = stories
                    print("Fetch Stories Success!")
                case .failure(let error):
                    print("Fetch failed: \(error)")
                }
                // Completion handler, used to tell pull-to-refresh control to stop refreshing
                completion?()
            }
        } else if let sg = searchGenre {
            // Searching by genre/category
            // Queries Story instances, explicitly including the user property, chapters, and sorted
            let query = Story.query(containsString(key: "categories", substring: sg)).include("user").include("chapters").order([.descending("createdAt")]).where("isPublished" == true)
            // Finding and returning the stories
            query.find {
                [weak self] result in
                switch result {
                case .success(let stories):
                    // Updating the local stories property with the fetched stories
                    self?.stories = stories
                    print("Fetch Stories Success!")
                case .failure(let error):
                    print("Fetch failed: \(error)")
                }
                // Completion handler, used to tell pull-to-refresh control to stop refreshing
                completion?()
            }
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
// Conforming ViewController to table view data source
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? StoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: stories[indexPath.row])
        return cell
    }
    
    
}
