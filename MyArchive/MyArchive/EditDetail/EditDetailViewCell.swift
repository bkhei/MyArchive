//
//  EditDetailViewCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/17/23.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

// Protocol to communicate with parent view controller EditDetail
protocol EditDetailCellDelegate: AnyObject {
    func updateStory(_ newStory: Story)
    func reloadInfo()
}

class EditDetailViewCell: UITableViewCell, UITextFieldDelegate {
    // Delegate property
    weak var delegate: EditDetailCellDelegate?
    
    // Outlets
    // detail
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var genre1Label: UILabel!
    @IBOutlet weak var deleteGenreLabel1: UIButton!
    @IBOutlet weak var genre2Label: UILabel!
    @IBOutlet weak var deleteGenreLabel2: UIButton!
    @IBOutlet weak var genre3Label: UILabel!
    @IBOutlet weak var deleteGenreLabel3: UIButton!
    @IBOutlet weak var genre3PopUpMenu: UIButton!
    // chapters
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var chapterTitleLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    var localStory: Story? = nil
    var tempCat: String = "None"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ tf: UITextField) {
        // Focus removed
        print("Focus removed")
        let newText = tf.text
        print("New Text: \(newText)")
        if tf.tag == 0 {
            // title text field
            localStory?.title = newText
            delegate?.updateStory(localStory!)
            print("New title: \(localStory?.title)")
        } else if tf.tag == 1 {
            // Summary text field
            localStory?.description = newText
            delegate?.updateStory(localStory!)
            print("New title: \(localStory?.title)")
        }
    }
    
    @IBAction func deleteG1(_ sender: Any) {
        if var genre = genre1Label.text, let index = localStory?.categories?.firstIndex(of: genre) {
            localStory?.categories?.remove(at: index)
            delegate?.updateStory(localStory!)
            delegate?.reloadInfo()
        } else {
            print("No category to remove!")
        }
    }
    @IBAction func deleteG2(_ sender: Any) {
        if let genre = genre2Label.text,
           let index = localStory?.categories?.firstIndex(of: genre){
            localStory?.categories?.remove(at: index)
            delegate?.updateStory(localStory!)
            delegate?.reloadInfo()
        } else {
            print("No category to remove!")
        }
    }
    @IBAction func deleteG3(_ sender: Any) {
        if let genre = genre3Label.text,
           let index = localStory?.categories?.firstIndex(of: genre){
            localStory?.categories?.remove(at: index)
            delegate?.updateStory(localStory!)
            delegate?.reloadInfo()
        } else {
            print("No category to remove!")
        }
    }
    @IBAction func addGenre(_ sender: Any) {
        if let numCat = localStory?.categories?.count {
            if numCat == 3 {
                print("A story can only have a maximum of 3 categories!")
            }else if tempCat == "None"{
                print("No selection made!")
            }else if let index = localStory?.categories?.firstIndex(of: tempCat) {
                print("\(tempCat) already included!")
            }else {
                print("Adding category \(tempCat)")
                localStory?.categories?.append(tempCat)
                delegate?.updateStory(localStory!)
                delegate?.reloadInfo()
            }
        }
    }
    
    func configureChapter(with title: String, with num: Int) {
        print("Chapter Info: \(title)")
        chapterTitleLabel.text = title
        chapterNumberLabel.text = String(num)
    }
    func configureDetail(with story: Story) {
        // Setting up Pop-up buttons
        let actionClosure = { (action: UIAction) in
            self.tempCat = String(describing: action.title)
        }
        var menuElements: [UIMenuElement] = []
        menuElements.append(UIAction(title: "None", handler: actionClosure))
        for genre in Genres {
            menuElements.append(UIAction(title: genre, handler: actionClosure))
        }
        genre3PopUpMenu.menu = UIMenu(options: .displayInline, children: menuElements)
        
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
        
        localStory = story
    }
}
