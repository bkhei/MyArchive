//
//  ReadCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/29/23.
//

import UIKit

class ReadCell: UITableViewCell {
    // Outlets
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
    
    func configure(_ chapter: Chapter) {
        titleTextField.text = chapter.title
        contentTextView.text = chapter.content
    }
}
