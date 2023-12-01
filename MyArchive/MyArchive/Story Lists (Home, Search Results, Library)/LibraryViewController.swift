//
//  LibraryViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class LibraryViewController: UIViewController {
    // story property
    var stories: [Story]!

    // table view outlet
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view data source
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            queryStories {
                // Reload the table view once stories are fetched
                self.tableView.reloadData()
            }
        }

    private func queryStories(completion: (() -> Void)? = nil) {
           // Query to fetch stories
           let query = Story.query().include("user").order([.descending("createdAt")]).where("isPublished" == true)
           
           // Finding and returning the stories
           query.find {
               [weak self] result in
               switch result {
               case .success(let stories):
                   // Updating the local stories property with the fetched stories
                   self?.stories = stories
                   completion?()
               case .failure(let error):
                   print("Fetch failed: \(error)")
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
// Conforming view controller to UITableViewDataSource -- INCOMPLETE
extension LibraryViewController: UITableViewDataSource {
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
