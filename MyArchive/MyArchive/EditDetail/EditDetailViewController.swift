//
//  EditDetailViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift
import PhotosUI

class EditDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    var story: Story!
    var chapters = [Chapter] () {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        print("Story Passed: \(story)")
        
        // Set the publish button to "Publish" or "Unpublish"
        publishButton.title = story.isPublished ? "Unpublish" : "Publish"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryChapters()
    }
    // Navigation Bar Button Functions
    @IBAction func didTapSave(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0) // There is only 1 cell
        if let cell = tableView.cellForRow(at: indexPath) as? EditDetailViewCell {
            // Saving current values at save to local chapter instance
            self.story.title = cell.titleTextField.text
            self.story.description = cell.summaryTextField.text
        }
        story.save {
            [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let story):
                    print("Story saved! \(story)")
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
    }
    @IBAction func didTapPublish(_ sender: Any) {
        // Will modify isPublished property and save automatically
        story.isPublished = story.isPublished ? false : true
        publishButton.title = story.isPublished ? "Unpublish" : "Publish"
        story.save {
            [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let story):
                    print("Story saved! \(story)")
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        print("Row 0 tapped, ending editing")
        view.endEditing(true)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // pick image action functions
    @IBAction func didTapCover(_ sender: UITapGestureRecognizer) {
        if let tappedIMG = sender.view as? UIImageView {
            let location = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                // Accessing the cell using the indexPath
                if let cell = tableView.cellForRow(at: indexPath) as? EditDetailViewCell {
                    var config = PHPickerConfiguration()
                    config.filter = .images
                    config.preferredAssetRepresentationMode = .automatic
                    config.selectionLimit = 1
                    let picker = PHPickerViewController(configuration: config)
                    picker.delegate = cell
                    present(picker, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let ECVC = segue.destination as? EditChapterViewController {
            let i = indexPath.row - 1
            let tappedChapter = chapters[i]
            ECVC.chapter = tappedChapter
            ECVC.chapIndex = i
        }
        if let btn = sender as? UIBarButtonItem, 
            let ECVC = segue.destination as? EditChapterViewController {
            // Create new chapter and send to EditChapter
            var newChapter = Chapter()
            ECVC.chapter = newChapter
            ECVC.delegate = self
        }
    }
    // NEEDS FIXING, FUNCTIONAL WITHOUT THIS
    private func queryChapters(completion: (() -> Void)? = nil) {
        /*
         Creating a query to fetch story and initialize chapters based on current story
         Properties that are parse objects (Chapter in this case) stored by reference in Parse DB, so need to be explicityly included
         Getting chapters based on current story
         */
        if let story = story {
            //let storyConstraint: QueryConstraint = containsString(key: "objectId", substring: id)
            // Including chapters with user because the result of this will also be passed onto edit detail which needs chapter information
            var chapterIDS: [String]? = []
            for ch in story.chapters! {
                chapterIDS?.append(ch.objectId!)
            }
            let query = Chapter.query(containedIn(key: "objectId", array: chapterIDS!)).include("chapters").order([.ascending("createdAt")])
            // Finding and returning the stories
            query.find {
                [weak self] result in
                switch result {
                case .success(let chapters):
                    // Updating the local stories property with the fetched stories
                    self?.chapters = chapters
                    print("Chapter 1 fetched!: \(self!.chapters)")
                case .failure(let error):
                    print("Fetch failed: \(error)")
                }
                // Completion handler, used to tell pull-to-refresh control to stop refreshing
                completion?()
            }
        }
    }
}
// Conforming view controller to table view data source
extension EditDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int = 1) -> Int {
        return (story.chapters?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Configure with story details, first cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditDetailCell", for: indexPath) as? EditDetailViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titleTextField.delegate = cell
            cell.summaryTextField.delegate = cell
            cell.configureDetail(with: story)
            return cell
        } else {
            // Configure with story chapters, second cell and onward
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as? EditDetailViewCell else {
                return UITableViewCell()
            }
            var chapterTitle = Chapter(title: "Default", content: "Default")
            if chapters != nil && chapters.count != 0 {
                let chapTitle = chapters[indexPath.row - 1]
                print("Chapter title: \(chapTitle)")
                chapterTitle = chapTitle
            }
            cell.configureChapter(with: chapterTitle, with: indexPath.row)
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
// Adopting EditChapter protocol
extension EditDetailViewController: EditChapterViewControllerDelegate {
    func addChapter(with chapter: Chapter) {
        // Appending chapter
        story.chapters?.append(chapter)
        print("\n Appending chapter! \(story.chapters)")
        // Saving story to db with new chapter
        story.save {
            [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let story):
                    print("Story saved! \(story)")
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
    }
}
