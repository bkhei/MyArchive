//
//  EditDetailViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class EditDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var story: Story? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        // Check if it's a new story or an existing story
        guard story != nil else {
            // if story is nil (a new story), create new story, chapter list/array, and cover
            story = Story()
            story?.chapters = []
            guard let image = UIImage(named: "DefaultCover"),
                  // Create and compress image data (jpeg) from UIImage
                  let imageData = image.jpegData(compressionQuality: 0.1) else {
                    return
            }
            // Create a Parse File by providing a name and passing in the image data
            let imageFile = ParseFile(name: "image.jpg", data: imageData)
            story?.coverFile = imageFile
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let ECVC = segue.destination as? EditChapterViewController {
            let tappedChapter = story!.chapters![indexPath.row - 1]
            ECVC.chapter = tappedChapter
        }
    }
    

}
// Conforming view controller to table view data source
extension EditDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int = 1) -> Int {
        return (story!.chapters?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Configure with story details, first cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditDetailCell", for: indexPath) as? EditDetailViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureDetail(with: story!)
            return cell
        } else {
            // Configure with story chapters, second cell and onward
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as? EditDetailViewCell else {
                return UITableViewCell()
            }
            cell.configureChapter(with: story!.chapters![indexPath.row - 1], with: indexPath.row)
            return cell
        }
        
    }
    
    
}

// Adopting Cell protocol
extension EditDetailViewController: EditDetailCellDelegate {
    func updateStory(_ newStory: Story) {
        story = newStory
    }
    func reloadInfo() {
        self.tableView.reloadData()
    }
}
