//
//  YourStoriesViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit
import ParseSwift

class YourStoriesViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    // Stories array, will be initialized in query function
    private var stories = [Story]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        print("Your Stories Loaded!")
        
        
        
        //TEMPORARY, SETTING USER LIBRARIES
        if var user = User.current {
            user.library = []
            print("New Library Set! \(user.library)")
        }
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
         Getting stories created by the current user
         */
        // Queries Story instances, explicitly including the user property and sorted
        if let currentUser = User.current {
            let userConstraint: QueryConstraint = containsString(key: "user", substring: currentUser.objectId ?? "")
            // Including chapters with user because the result of this will also be passed onto edit detail which needs chapter information
            let query = Story.query(userConstraint).include("user").order([.descending("createdAt")])
            // Finding and returning the stories
            query.find {
                [weak self] result in
                switch result {
                case .success(let stories):
                    // Updating the local stories property with the fetched stories
                    self?.stories = stories
                    print("Stories fetched!: \(stories)")
                case .failure(let error):
                    print("Fetch failed: \(error)")
                }
                // Completion handler, used to tell pull-to-refresh control to stop refreshing
                completion?()
            }
        }
        
    }
    
    // Prepare for segue and send data to edit detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let EDVC = segue.destination as? EditDetailViewController {
            let tappedStory = stories[indexPath.row]
            EDVC.story = tappedStory
        }
        if let btn = sender as? UIBarButtonItem,
            let EDVC = segue.destination as? EditDetailViewController {
            // Initializing newStory, will only be used if user taps New Story
            // Setting all string properties to empty, because all additions/deletions will assume an array exists and use append
            var newStory = Story()
            newStory.categories = []
            newStory.chapters = []
            newStory.user = User.current
            guard let image = UIImage(named: "DefaultCover"),
                  let imageData = image.jpegData(compressionQuality: 0.1) else {
                    return
            }
            // Create a Parse File by providing a name and passing in the image data
            let imageFile = ParseFile(name: "image.jpg", data: imageData)
            newStory.coverFile = imageFile
            EDVC.story = newStory
        }
    }

}
extension YourStoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourStoryCell", for: indexPath) as? YourStoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: stories[indexPath.row])
        return cell
    }
    
    
}
