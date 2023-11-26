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
    // Hold filtered stories
        private var filteredStories = [Story]()

        override func viewDidLoad() {
            super.viewDidLoad()
            searchBar.delegate = self
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // Conforming to UISearchBarDelegate to handle search bar interactions
    extension SearchViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // Optionally implement a debounce mechanism to wait for the user to stop typing
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let title = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty {
                searchStories(byTitle: title)
            }
            searchBar.resignFirstResponder() // Hide the keyboard
        }
    }

    // Conforming to UITableViewDataSource to populate the table view
    extension SearchViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredStories.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as? StoryCell else {
                fatalError("Could not dequeue StoryCell")
            }
            let story = filteredStories[indexPath.row]
            cell.configure(with: story)
            return cell
        }
    }

    // Optionally implement UITableViewDelegate if you want to handle row selection
    extension SearchViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle selection event, e.g., navigate to a detail view controller for the selected story
        }
    }


    // Extension for search functionality
    extension SearchViewController {
        private func searchStories(byTitle title: String) {
            // Use a "contains" query to find stories where the title includes the search text
            let query = Story.query().where("title", matchesRegex: title, modifiers: "i") // 'i' for case-insensitive
            query.find { [weak self] result in
                switch result {
                case .success(let stories):
                    self?.filteredStories = stories
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching stories by title: \(error)")
                }
            }
        }
    }
