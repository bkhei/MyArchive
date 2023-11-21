//
//  EditChapterCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/20/23.
//

import UIKit

// Protocol to communicate with parent view controller EditChapter
protocol EditChapterCellDelegate: AnyObject {
    func updateChapter(_ newChapter: Chapter)
    func reloadInfo()
}

class EditChapterCell: UITableViewCell {
    // Delegate property
    weak var delegate: EditChapterCellDelegate?
    
    // OUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure Function
    func configure(_ chapter: Chapter) {
        // Configure with story details, first cell
        titleTextField.text = chapter.title
        contentTextView.text = chapter.content
    }
}
