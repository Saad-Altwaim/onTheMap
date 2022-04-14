//
//  TableViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/1/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController
{

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        studentData()
    }
    
    func studentData()
    {
        udacityApiClient.studentNames
        {
            (studentName , error) in
            UdacityDataModel.infoList = studentName
            if UdacityDataModel.infoList == [] || error != nil // note 1 Page 195 
            {
                DispatchQueue.main.async
                {
                    let alertVC = UIAlertController(title: "Error", message: "Problem in loading  Data", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC,animated: true, completion: nil)
                }
            }
            else
            {
                print("NO Error in ListTableViewController")
                print("UdacityDataModel",UdacityDataModel.infoList)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }

    @IBAction func refreshButton(_ sender: Any)
    {
        tableView.reloadData()
        tableView.delegate = self
        studentData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UdacityDataModel.infoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath)
        
        let DataModel = UdacityDataModel.infoList[indexPath.row]
        
        let fullName = DataModel.firstName + " " +  DataModel.lastName
        
        cell.textLabel?.text = fullName
        cell.imageView?.image = UIImage(named: "mapICON")

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dataRow = UdacityDataModel.infoList[indexPath.row]
        
        UIApplication.shared.open(URL(string:dataRow.mediaURL)!, options: [:], completionHandler: nil)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
