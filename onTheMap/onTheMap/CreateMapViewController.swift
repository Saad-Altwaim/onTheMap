//
//  CreateMapViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/10/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit
import MapKit

class CreateMapViewController: UIViewController ,MKMapViewDelegate
{
    var locationdatafromVC = ""
    var linkDataFromVC = ""

    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchInMap()
       // mapview.delegate = self 

        // Do any additional setup after loading the view.
    }
    

    func searchInMap()
    {
        //var newMap = "Fortnum and Mason, London"
        let QueryData = locationdatafromVC
        print ("THE VALUE NEW MAP ",QueryData)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = QueryData
        
        let sreach = MKLocalSearch(request: request)
        
        sreach.start
        {
            (MKResponse, Error) in
            
            for info in MKResponse!.mapItems
            {
                print("Message from [AddInfoViewController] ")
                print("Name",info.name as Any,
                      "Lat : ",info.placemark.location?.coordinate.latitude as Any,
                      "long: ",info.placemark.location?.coordinate.longitude as Any)
                
                self.addToMap(title: info.name, lat: info.placemark.location?.coordinate.latitude as! Double,
                                              long: info.placemark.location?.coordinate.longitude as! Double)
            }
        }
    }
    
    func addToMap(title :String?,lat :CLLocationDegrees,long :CLLocationDegrees ) //-> MKPointAnnotation
    {
        if let title = title
        {
            let location    = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation  = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            self.mapview.addAnnotation(annotation)
        }
    }
    /*
    @IBAction func Cancelbutton()
    {
        let cancelButton = self.storyboard!.instantiateViewController(withIdentifier: "AddInfoViewController") as! AddInfoViewController
        self.navigationController!.pushViewController(cancelButton, animated: true)
    }
    
    @IBAction func Cancelbutton()
    {
        self.navigationController!.popToRootViewController(animated: true)
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
