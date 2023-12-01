//
//  ReadViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class ReadViewController: UIViewController {
    // story property
    var chapters: [Chapter]!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        print("Read View Loaded!")
        //print("Chapters: \(chapters)")
    }
    

}
extension ReadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReadCell", for: indexPath) as? ReadCell else {
            return UITableViewCell()
        }
        cell.configure(chapters[indexPath.row])
        return cell
    }
    
    
}

