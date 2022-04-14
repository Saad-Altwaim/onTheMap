//
//  ViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/1/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController ,MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        studentLocations()

    }
    
    func studentLocations()
    {
        udacityApiClient.studentNames
        {
            (studentName , error) in
            //print("from loginViewController ",studentName)
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
               
            print("UdacityDataModel",UdacityDataModel.infoList)
            print("UdacityDataModel Count : ",UdacityDataModel.infoList.count)
            print("NO Error in MapViewController")
            self.JsonMap()
            }
        }
    }
    func JsonMap() // note page 192
    {
        let jsonLocations = UdacityDataModel.infoList
        print("theCount : ",jsonLocations.count)
        
        var mapAnnotations = [MKPointAnnotation]()
        
        for jsonDispaly in jsonLocations
        {
            let lat  = CLLocationDegrees(jsonDispaly.latitude)
            let long = CLLocationDegrees(jsonDispaly.longitude)
            
            let jsonCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = jsonDispaly.firstName
            let lastName  = jsonDispaly.lastName
            let mideaURL  = jsonDispaly.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = jsonCoordinate
            annotation.title = firstName + "" + lastName
            annotation.subtitle = mideaURL
            
            mapAnnotations.append(annotation)
        }
        
        self.mapView.addAnnotations(mapAnnotations)
    }

   
    override func viewWillAppear(_ animated: Bool)
    {
        mapView.delegate = self
        super.viewWillAppear(animated)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        let mapPin = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: mapPin) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: mapPin)
            pinView?.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
            
        else
        {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            let app = UIApplication.shared
            
            if let detailButton = view.annotation?.subtitle!
            {
                app.open(URL(string: detailButton)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any)
    {
        mapView.delegate = self
        studentLocations()
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
