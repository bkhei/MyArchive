//
//  SearchCell.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/28/23.
//

import UIKit

class SearchCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ genre: String!) {
        genreLabel.text = genre
    }
}
