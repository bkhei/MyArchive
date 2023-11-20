//
//  DetailCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/8/23.
//

import UIKit
import Alamofire
import AlamofireImage

// Delegate protocol
protocol DetailCellDelegate: AnyObject {
    func requestStoryProperty() -> Story
    func reloadTable()
}

class DetailCell: UITableViewCell {
    // Delegate
    weak var delegate: DetailCellDelegate?
    
    // Outlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var addLibraryImageView: UIImageView!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genre1Label: UILabel!
    @IBOutlet weak var genre2Label: UILabel!
    @IBOutlet weak var genre3Label: UILabel!

    private var imageDataRequest: DataRequest?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addLibraryTapped(_ sender: Any) {
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
        self.delegate?.reloadTable()
    }

    func configure(with story: Story)  {
        // Setting cover
        // Getting cover file and url
        if let coverFile = story.coverFile,
           let coverURL = coverFile.url {
            // Using alamofireimage to fetch remote image from the url
               imageDataRequest = AF.request(coverURL).responseImage {
                   [weak self] response in
                   switch response.result {
                   case .success(let image):
                       // Successful request, setting image view with fetched image
                       self?.coverImageView.image = image
                   case .failure(let error):
                       print("Error fetching image: \(error)")
                       break
                   }
               }
        }
        
        // Setting add library
        // If story is already in library, minus sign, if not in library, plus sign, to do this must access current user's library
        let inLibrary = checkLibrary(User.current!)
        addLibraryImageView.image = UIImage(systemName: inLibrary ? "minus.circle.fill" : "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        addLibraryImageView.tintColor = story.isPublished ? .systemBlue : .tertiaryLabel
        
        // Setting Username
        usernameLabel.text = story.user?.username
        
        // Setting title
        titleLabel.text = story.title
        
        // Setting description
        descriptionLabel.text = story.description
        
        // Setting category labels
        // Storing story categories in local array
        var localCat = ["0", "0", "0"]
        if let numCat = story.categories?.count {
            // Filling local array with actual categories, if no catagory at a particular index, keep 0
            if numCat != 1 && numCat != 0 {
                for i in 0...numCat-1 {
                    localCat[i] = story.categories![i]
                }
            } else if numCat == 1 {
                localCat[0] = story.categories![0]
            }
            for i in 0...localCat.count-1 {
                if localCat[i] == "0" {
                    // if there's a 0, means no category, make empty
                    localCat[i] = ""
                }
            }
        }
        genre1Label.text = localCat[0]
        genre2Label.text = localCat[1]
        genre3Label.text = localCat[2]
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
}
