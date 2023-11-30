//
//  SearchViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class SearchViewController: UIViewController {
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filterSearch: [String]!
    var searchText: String? = ""
    var titles: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note, Genres is a global variable that holds an array of strings
        filterSearch = Genres
        titles = []
        searchBar.delegate = self
        tableView.delegate = self
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
         Getting stories where isPublished is true
         */
        // Queries Story instances, explicitly including the user property and sorted
        let query = Story.query().include("user").include("chapters").order([.descending("createdAt")]).where("isPublished" == true)
        // Finding and returning the stories
        query.find {
            [weak self] result in
            switch result {
            case .success(let stories):
                // Updating the local stories property with the fetched stories
                for s in stories {
                    self?.titles.append(s.title!)
                }
                print("Titles: \(self?.titles)")
            case .failure(let error):
                print("Fetch failed: \(error)")
            }
            // Completion handler, used to tell pull-to-refresh control to stop refreshing
            completion?()
        }
    }

    // Prepare for segue and send data to edit detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let SRVC = segue.destination as? SearchResultViewController {
            //let tappedStory = stories[indexPath.row]
            //SRVC.story = tappedStory
        } else {
            if let SRVC = segue.destination as? SearchResultViewController {
                print("Setting search property")
                SRVC.search = searchText
            }
        }
    }

}
// Conforming to tableView Data Source and Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        cell.configure(filterSearch[indexPath.row])
        return cell
    }
    
    
}
// Conforming to UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch = []
        if searchText == "" {
            // If no text entered
            filterSearch = Genres
        }
        // cycling through each available and seeing it it contains what was searched
        var localGenres = Genres
        let searchArray = localGenres + titles
        print("SearchArray: \(searchArray)")
        for word in searchArray {
            if word.uppercased().contains(searchText.uppercased()) {
                filterSearch.append(word)
            }
        }
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text
        performSegue(withIdentifier: "getResults", sender: nil)
    }
}
