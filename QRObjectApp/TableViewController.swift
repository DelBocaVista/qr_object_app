//
//  TableViewController.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-03-06.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import UIKit
import ARKit

class ARItemTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    /*@IBOutlet weak var dateLabel: UILabel!
     @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!*/
}

class TableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        //table.delegate = self
        
        table.rowHeight = 90.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arItemsModel.getARItemsData().count
    }
    
    /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return weatherModel.getWeatherData().count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
     as! WeatherTableViewCell
     
     let formatDate = DateFormatter()
     formatDate.dateFormat = "yyyy-MM-dd HH:mm"
     
     cell.dateLabel?.text = formatDate.string(from: weatherModel.getWeatherData()[indexPath.row].date)
     cell.temperatureLabel?.text = weatherModel.getWeatherData()[indexPath.row].temperature.description  + "℃"
     cell.cloudCoverLabel?.text = translateWeatherToIcon(forecast: weatherModel.getWeatherData()[indexPath.row])
     
     return cell
     }
     */
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! ARItemTableViewCell
        
        let arItem = arItemsModel.getARItemsData()[indexPath.row]
        
        if let image = UIImage(named: arItem.img) {
            cell.itemImageView?.image = image
        }
        
        cell.nameLabel?.text = arItem.name
        cell.descriptionLabel?.text = arItem.description
        
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
