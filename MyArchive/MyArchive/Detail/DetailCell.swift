//
//  DetailCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/8/23.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var addLibraryImageView: UIImageView!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabelL: UILabel!
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
        let inLibrary = checkLibrary(with: User.current, with: story)
        addLibraryImageView.image = UIImage(systemName: story.isPublished ? "book.fill" : "book.closed.fill")?.withRenderingMode(.alwaysTemplate)
        addLibraryImageView.tintColor = story.isPublished ? .systemBlue : .tertiaryLabel
        
        // Setting title
        titleLabel.text = story.title
        
        // Setting description
        descriptionLabel.text = story.description
    }
    func checkLibrary(with user: User, with story: Story) {
        for s in user.library {
            if (story == s) {
                return true
            }
        }
        return false
    }
}
