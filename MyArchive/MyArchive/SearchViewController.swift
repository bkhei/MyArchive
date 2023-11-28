//
//  SearchViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [String]()
    // Functions
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){ // called when keyboard search button pressed
        searchBar.resignFirstResponder()
        
        guard let searchResults = searchBar.text else {return}
        // Query to match title
        var titleQuery = Story.Query(title?.contains(searchResults) == true)
        // Query to match desc
        let descQuery = Story.Query(description?.contains(searchResults) == true)
        
        
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){ // called when cancel button pressed
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as UITableViewCell
        
        
        newCell.textLabel?.text = searchResults[indexPath.row]
        return newCell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.delegate = self
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
    // Conforming to searchBar Delegate
