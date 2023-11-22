//
//  EditChapterViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

protocol EditChapterViewControllerDelegate: AnyObject {
    func addChapter(with chapter: Chapter)
}

class EditChapterViewController: UIViewController {
    // Delegate
    weak var delegate: EditChapterViewControllerDelegate?
    
    var chapter: Chapter!
    var chapIndex: Int? = nil
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        // Saving changes to local chapter property
        let indexPath = IndexPath(row: 0, section: 0) // There is only 1 cell
        if let cell = tableView.cellForRow(at: indexPath) as? EditChapterCell {
            // Saving current values at save to local chapter instance
            self.chapter.title = cell.titleTextField.text
            self.chapter.content = cell.contentTextView.text
        }
        
        // Saving the local chapter instance to db
        chapter.save {
            [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let chapter):
                    print("Chapter saved! \(chapter)")
                    // Check if the given chapter is an existing chapter or new chapter
                    if self?.chapIndex == nil {
                        print("\n Chapter is new! Adding to story")
                        // chapIndex is null, no chapIndex passed because chapter is new
                        // Append chapter to the local story in EditDetail
                        self?.delegate?.addChapter(with: chapter)
                        print("CHAPTER ADDED")
                    }
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
        
        
    }
}
// Conforming to table view data source
extension EditChapterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditChapterCell", for: indexPath) as? EditChapterCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        //cell.titleTextField.delegate = cell
        //cell.contentTextView.delegate = cell
        cell.configure(chapter)
        return cell
    }
    
    
}
// Conforming to Table Cell delegate
extension EditChapterViewController: EditChapterCellDelegate {
    func updateChapter(_ newChapter: Chapter) {
        chapter = newChapter
    }
    func reloadInfo() {
        self.tableView.reloadData()
    }
}
