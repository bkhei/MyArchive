//
//  YourStoryCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/7/23.
//

import UIKit
import Alamofire
import AlamofireImage

class YourStoryCell: UITableViewCell {
    // Outlets -- NOT CONNECTED YET
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isPublishedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        
        // Setting is published signal
        // If isPublished is true, image will be opened book, other wise it will be a closed book
        isPublishedImageView.image = UIImage(systemName: story.isPublished! ? "book.fill" : "book.closed.fill")?.withRenderingMode(.alwaysTemplate)
        isPublishedImageView.tintColor = story.isPublished! ? .systemBlue : .tertiaryLabel
        
        // Setting title
        titleLabel.text = story.title
        
        // Setting description
        descriptionLabel.text = story.description
    }
}
