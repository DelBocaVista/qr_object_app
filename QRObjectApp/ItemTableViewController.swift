//
//  ItemTableViewController.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-03-06.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class ItemTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func button(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToARSCNView2", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.rowHeight = 90.0
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arItemsModel.getARItemsData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        let arItem = arItemsModel.getARItemsData()[indexPath.row]
        
        if let image = UIImage(named: "emote_" + arItem.img) {
            cell.itemImageView?.image = image
        }
        
        cell.nameLabel?.text = arItem.name
        cell.descriptionLabel?.text = arItem.description
        
        
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
