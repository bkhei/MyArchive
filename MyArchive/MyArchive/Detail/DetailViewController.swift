//
//  DetailViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class DetailViewController: UIViewController {    
    // Story propety
    var story: Story!
    // Table View
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view data source
        tableView.dataSource = self
    }
    

    // Prepare for segue and send data to read view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RVC = segue.destination as? ReadViewController {
            let story = story
            RVC.story = story
        }
    }

}
// Conforming DetailViewController to UITableViewDataSoucre
extension DetailViewController: UITableViewDataSource, DetailCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // There will only be one cell, details of only 1 story is shown
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell else {
            return UITableViewCell()
        }
        cell.configure(with: story)
        cell.delegate = self
        return cell
    }
    // Delegate function
    func requestStoryProperty() -> Story {
        return story
    }
    
}
