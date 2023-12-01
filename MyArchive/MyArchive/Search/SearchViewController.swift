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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note, Genres is a global variable that holds an array of strings
        filterSearch = Genres
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
        for word in Genres {
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
