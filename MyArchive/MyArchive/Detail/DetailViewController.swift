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
    
    func checkLibrary(_ user: User) -> Bool {
        let story = delegate?.requestStoryProperty()
        if (user.library.isEmpty) {
            return false
        } else {
            for s in user.library {
                if (story == s) {
                    return true
                }
            }
            return false
        }
    }

    // Prepare for segue and send data to read view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RVC = segue.destination as? ReadViewController {
            let story = story
            RVC.chapters = story?.chapters
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
    func reloadTable() {
        self.tableView.reloadData()
    }
}
// Tap gesture funcitons
extension ReadViewController {
    @IBAction func onViewTapped(_ sender: Any) {
        print("Row 0 tapped, ending editing")
        view.endEditing(true)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func didTapAddLibrary(_ sender: UITapGestureRecognizer) {
        if let tappedIMG = sender.view as? UIImageView {
            // Accessing the tapped image (there is only 1)
            // Add current story to current user's library
            // Checking whether in library or not
            let inLibrary = checkLibrary(User.current!)
            let story = delegate?.requestStoryProperty()
            var currentUser = User.current!
            // Add library button/gesture tapped
            if (inLibrary == true) {
                // already in library, tapped to remove
                currentUser.library = currentUser.library.filter {$0 != story}
            } else {
                // Appending current story to current user's library array
                currentUser.library.append(story!)
            }
            // Saving user with the updated library
            currentUser.save {
                [weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        print("User saved! \(user)")
                    case .failure(let error):
                        print("Save Error: \(error)")
                    }
                }
            }
            // Reloading table view to update addLibrary button/gesture image
            tableView.reloadTable()
            
            // Change add library button based on whether current story is in the library or not
        }
    }
}
