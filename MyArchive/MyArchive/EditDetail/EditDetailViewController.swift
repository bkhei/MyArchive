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
        publishButton.title = story.isPublished! ? "Unpublish" : "Publish"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryStory()
        queryChapters()
    }
    // Navigation Bar Button Functions
    @IBAction func didTapSave(_ sender: Any) {
        saveStory()
    }
    @IBAction func didTapPublish(_ sender: Any) {
        // Will modify isPublished property and save automatically
        story.isPublished = story.isPublished! ? false : true
        publishButton.title = story.isPublished! ? "Unpublish" : "Publish"
        print(story.isPublished! ? "Publishing..." : "Unpublishing...")
        saveStory()
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
        // Saving story to DB if it is new
        if story.isSaved == false {
            saveStoryPrep { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let savedStory):
                        self?.story = savedStory
                        print("Story saved! \(savedStory.objectId)")
                    case .failure(let error):
                        print("Failed to save story: \(error)")
                    }
                }
            }
        }
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let ECVC = segue.destination as? EditChapterViewController {
            // Tapped on existing chapter
            let i = indexPath.row - 1
            let tappedChapter = chapters[i]
            ECVC.chapter = tappedChapter
            ECVC.chapIndex = i
        }
        if let btn = sender as? UIBarButtonItem, 
            let ECVC = segue.destination as? EditChapterViewController {
            // Tapped on add a chapter
            // Create new chapter and send to EditChapter
            var newChapter = Chapter()
            ECVC.chapter = newChapter
            ECVC.delegate = self
        }
    }
    
    // Save story
    private func saveStory() {
        print("Saving stories...")
        let indexPath = IndexPath(row: 0, section: 0) // There is only 1 cell
        if let cell = tableView.cellForRow(at: indexPath) as? EditDetailViewCell {
            // Saving current values (coverFile, title, description) at save to local story instance "story"
            // Categories are saved to the db on change in EditDetail
            // coverFile are saved to EditDetail's local story instance "localStory" on change
            // title and description are retrieved from the current values in the UIElements
            self.story.coverFile = cell.localStory?.coverFile
            self.story.title = cell.titleTextField.text
            self.story.description = cell.summaryTextField.text
        }
        print("saving 1")
        story.save {
            [weak self] result in
            print("saving 2")
            DispatchQueue.main.async {
                switch result {
                case .success(let story):
                    self?.story = story
                    print("Story saved! \(story.objectId)")
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
    }
    private func saveStoryPrep(completion: @escaping (Result<Story, ParseError>) -> Void) {
        print("Saving stories...")
        let indexPath = IndexPath(row: 0, section: 0) // There is only 1 cell
        if let cell = tableView.cellForRow(at: indexPath) as? EditDetailViewCell {
            // Saving current values (coverFile, title, description) at save to local story instance "story"
            // Categories are saved to the db on change in EditDetail
            // coverFile are saved to EditDetail's local story instance "localStory" on change
            // title and description are retrieved from the current values in the UIElements
            self.story.coverFile = cell.localStory?.coverFile
            self.story.title = cell.titleTextField.text
            self.story.description = cell.summaryTextField.text
        }
        print("saving 1")
        story.save {
            [weak self] result in
            print("saving 2")
            completion(result)
        }
    }
    private func queryStory(completion: (() -> Void)? = nil) {
        /*
         Creating a query to fetch story and initialize chapters based on current story
         Properties that are parse objects (Chapter in this case) stored by reference in Parse DB, so need to be explicityly included
         Getting chapters based on current story
         */
        if let storyID = story.objectId {
            // story exists already in DB
            let query = Story.query(containsString(key: "objectId", substring: story.objectId!)).include("chapters").include("user")
            // Finding and returning the stories
            query.find {
                [weak self] result in
                switch result {
                case .success(let stories):
                    // Updating the local stories property with the fetched stories
                    self?.story = stories[0]
                    print("Story Fetched! \(stories[0].objectId)")
                case .failure(let error):
                    print("Fetch failed: \(error)")
                }
                // Completion handler, used to tell pull-to-refresh control to stop refreshing
                completion?()
            }
        } else {
            // Story does not exist yet
        }
    }
    private func queryChapters(completion: (() -> Void)? = nil) {
        /*
         Creating a query to fetch story and initialize chapters based on current story
         Properties that are parse objects (Chapter in this case) stored by reference in Parse DB, so need to be explicityly included
         Getting chapters based on current story
         */
        if story != nil {
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
                    print("Chapter 1 fetched!")
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
            //cell.titleTextField.delegate = cell
            //cell.summaryTextField.delegate = cell
            cell.localStory = story
            cell.configureDetail(with: story)
            return cell
        } else {
            // Configure with story chapters, second cell and onward
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as? EditDetailViewCell else {
                return UITableViewCell()
            }
            var chapterTitle = Chapter(title: "Default", content: "Default")
            if chapters != nil && chapters.count != 0 {
                let chap = chapters[indexPath.row - 1]
                print("Chapter title: \(chap.title)")
                chapterTitle = chap
            }
            cell.configureChapter(with: chapterTitle, with: indexPath.row)
            return cell
        }
        
    }
    
    
}
// Adopting Cell protocol
extension EditDetailViewController: EditDetailCellDelegate {
    func updateStory(_ newStory: Story) {
        self.story = newStory
    }
    func reloadInfo() {
        self.tableView.reloadData()
    }
}
// Adopting EditChapter protocol
extension EditDetailViewController: EditChapterViewControllerDelegate {
    func addChapter(with chapter: Chapter) {
        print("Querying story...")
        // Appending chapter
        self.story.chapters?.append(chapter)
        print("Appending chapter...")
        // Saving story to db with new chapter
        saveStoryPrep { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedStory):
                    self?.story = savedStory
                    print("Story saved! \(savedStory.objectId)")
                case .failure(let error):
                    print("Failed to save story: \(error)")
                }
            }
        }
        print("Story saved with new chapter! \(String(describing: self.story.objectId))")
    }
}
