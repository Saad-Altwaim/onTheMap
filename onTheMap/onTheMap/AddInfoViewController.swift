//
//  AddInfoViewController.swift
//  onTheMap
//
//  Created by Saad altwaim on 11/10/20.
//  Copyright © 2020 Saad Altwaim. All rights reserved.
//

import UIKit
import MapKit

class AddInfoViewController: UIViewController,MKMapViewDelegate,UINavigationControllerDelegate, UITextFieldDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var profileLink: UITextField!
    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var active: UIActivityIndicatorView!
    
    var firstName_AL : String = ""
    var lastName_AL  : String = ""
    var Latitude_AL  : Double = 0.0
    var Longitude_AL : Double = 0.0 //CLLocationCoordinate2D = CLLocationCoordinate2D()
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        locationName.text = ""
        profileLink.text  = ""
        
        locationName.delegate = self
        profileLink.delegate = self
        
        mapView.isHidden = true //note 7 Page 193
        addLocation.isHidden = true
         
        udacityApiClient.userInfo(id: UserKey.Value)
        {
            (dataKey, error) in
            UserDataKey.DataKeyValue = dataKey
 
            let value = UserDataKey.DataKeyValue
            for printValue in value
            {
                self.firstName_AL = printValue.first_name
                self.lastName_AL = printValue.last_name
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(AddInfoViewController.keyboardWillHide)
        , name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func infoButton()  // note 2 Page 193
    {
        if self.locationName.text == "" || self.profileLink.text == "" // note 1 Page 193
        {
            showaddLocationMessage(Title: "Failed to add location ", Message: "location OR profileLink is Empty ")
        }
         else
        {
           self.locationName.resignFirstResponder()
           self.profileLink.resignFirstResponder() // note 2 Page 195
           self.mapView.isHidden = false //note 7 Page 193
           self.addLocation.isHidden = false
           searchInMap()
           loadingDataPic(true)

            //self.performSegue(withIdentifier: "OK", sender: nil) // note 2 Page 193
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) // note 3 Page 193
    {
        if segue.destination is CreateMapViewController
        {
            let VC = segue.destination as? CreateMapViewController
            VC?.locationdatafromVC = self.locationName.text ?? ""
            VC?.linkDataFromVC = self.profileLink.text ?? ""
        }
    }*/
    
    func searchInMap()
    {
        let QueryData = self.locationName.text
        print ("THE VALUE NEW MAP ",QueryData ?? "")
        let request = MKLocalSearch.Request() // note 4 Page 193
        request.naturalLanguageQuery = QueryData
        
        let sreach = MKLocalSearch(request: request)
        
        sreach.start // 5 note page 193
        {
            (MKResponse, Error) in  // note 4 Page 195
            guard let MKResponse = MKResponse
            else
            {
                DispatchQueue.main.async
                {
                    self.showaddLocationMessage(Title: "Error", Message: "The Location name is incorrect")
                }
                self.loadingDataPic(false)
                return
            }
            
            for info in MKResponse.mapItems
            {
                print("Message from [AddInfoViewController] ")
                print("Name",info.name as Any,
                      "Lat : ",info.placemark.location?.coordinate.latitude as Any,
                      "long: ",info.placemark.location?.coordinate.longitude as Any)

                self.addToMap(title: info.name, lat: info.placemark.location?.coordinate.latitude as! Double,
                                              long: info.placemark.location?.coordinate.longitude as! Double)
                self.loadingDataPic(false)
            }
        }
    }
    
    func addToMap(title :String?,lat :CLLocationDegrees,long :CLLocationDegrees ) //-> MKPointAnnotation
    {
        if let title = title // note 6 page 193
        {
            let location    = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation  = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            
            let region = MKCoordinateRegion(center: annotation.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true) // note 5 Page 195
            
            self.mapView.addAnnotation(annotation)
            
            self.Latitude_AL = lat
            self.Longitude_AL = long

        }
    }
    @IBAction func Cancelbutton()
    {
        self.navigationController!.popToRootViewController(animated: true)
    }
    @IBAction func addLocationbutton()
    {
        addLocationInput(uniqueKey_ALI: UserKey.Value, firstName_ALI: self.firstName_AL, LastName_ALI: self.lastName_AL,
                         MapString_ALI: self.locationName.text ?? "", MediaURL_ALI: self.profileLink.text ?? "",
                         Latitude_ALI: self.Latitude_AL,Longitude_ALI: self.Longitude_AL)
    }
    func addLocationInput(uniqueKey_ALI:String, firstName_ALI:String, LastName_ALI:String, MapString_ALI:String, MediaURL_ALI:String,Latitude_ALI:Double, Longitude_ALI:Double)
    {
        udacityApiClient.addNewLocation(UniqueKey: uniqueKey_ALI ,FirstName:firstName_ALI, LastName: LastName_ALI,
                                        MapString:MapString_ALI, MediaURL:MediaURL_ALI ,Latitude: Latitude_ALI,
                                        Longitude: Longitude_ALI ,completion: self.handleaddLocationResponse(suceess:Error:))
    }
    func handleaddLocationResponse(suceess : Bool , Error :Error?)
    {
        if suceess == true
        {
            DispatchQueue.main.async
            {
                self.showaddLocationMessage(Title: "successful", Message: " Congratulations you add new Location")
                //self.navigationController!.popToRootViewController(animated: true)
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                self.showaddLocationMessage(Title: "Error", Message: " Error in adding a  new Location")
            }
        }
    }
    func showaddLocationMessage(Title:String,Message :String)
    {
        let alertVC = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC,animated: true, completion: nil)
    }
    
    // -KEYBORAD
    
    
       @objc func keyboardWillShow(_ notification:Notification)
       {
           self.view.frame.origin.y = -getKeyboardHeight(notification)
           var shouldMoveViewUp = false

            // if active text field is not nil
            if let activeTextField = activeTextField
            {

              let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
              
              let topOfKeyboard = view.frame.height - getKeyboardHeight(notification)

              // if the bottom of Textfield is below the top of keyboard, move up
              if bottomOfTextField < topOfKeyboard
              {
                shouldMoveViewUp = true
              }
            }

            if(shouldMoveViewUp)
            {
                self.view.frame.origin.y = 0
            }
       }
       
       @objc func keyboardWillHide(_ notification:Notification)
       {
           self.view.frame.origin.y = 0
       }
       
       func getKeyboardHeight(_ notification :Notification)-> CGFloat
       {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as! NSValue
           
           return keyboardSize.cgRectValue.height
           
       }
       
       func subscribeToKeyboardNotification()
       {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
               name: UIResponder.keyboardWillShowNotification, object: nil)
       }
       func subscribeToKeyboardNotificationH(){
          //dismiss(animated: true, completion: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
           name: UIResponder.keyboardWillHideNotification, object: nil)
       }


       func unsubscribeToKeyboardNotification()
       {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,object: nil)
           dismiss(animated: true, completion: nil)
       }
       
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        subscribeToKeyboardNotificationH()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
      // set the activeTextField to the selected textfield
      self.activeTextField = textField
        
    }
    
    func loadingDataPic(_ loadingON:Bool) // note 3 Page 195
    {
        if loadingON
        {
            active.startAnimating()
        }
        else
        {
            active.stopAnimating()
        }
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
