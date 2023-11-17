//
//  EditDetailViewCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/17/23.
//

import UIKit
import Alamofire
import AlamofireImage

class EditDetailViewCell: UITableViewCell {
    // Outlets
    // detail
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var genre1PopUpMenu: UIButton!
    @IBOutlet weak var genre2PopUpMenu: UIButton!
    @IBOutlet weak var genre3PopUpMenu: UIButton!
    // chapters
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var chapterTitleLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func getMenuState(_ genre: String) {
        
    }
    
    func configureChapter(with chapter: Chapter, with num: Int) {
        chapterTitleLabel.text = chapter.title
        chapterNumberLabel.text = String(num)
    }
    func configureDetail(with story: Story) {
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
        
        titleTextField.text = story.title
        summaryTextField.text = story.description
        /*genre1PopUpMenu.title = story.categories?[0] ?? ""
        genre2PopUpMenu.title = story.categories?[1] ?? ""
        genre3PopUpMenu.title = story.categories?[2] ?? ""*/
    }
}
