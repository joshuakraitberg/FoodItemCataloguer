//
//  FoodItemAddViewController.swift
//  Assign4
//
//  Created by josh on 2018-11-24.
//  Copyright © 2018 SICT. All rights reserved.
//

import UIKit
import CoreLocation


protocol AddFoodItemDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTaskDidSave(_ controller: UIViewController)
}

class FoodItemAdd: UIViewController, CLLocationManagerDelegate, FoodItemSearchListDelegate {
    
    // MARK: - Instance variables
    
    weak var delegate: AddFoodItemDelegate?
    
    var m: DataModelManager!
    
    var photo: UIImage?
    
    var foodItem: NdbSearchListItem?
    
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var locationRequests: Int = 0;
    
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var placemarkText = "(location not available)"
    
    // MARK: - User interface outlets
    
    @IBOutlet weak var infoBox: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var source: UITextField!
    @IBOutlet weak var quantity: UISegmentedControl!
    @IBOutlet weak var imagePicker: UIButton!
    @IBOutlet weak var notes: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style
        title = "Add food item"
        infoBox.isUserInteractionEnabled = false
        source.isUserInteractionEnabled = false
        infoBox.layer.cornerRadius = 5
        name.layer.cornerRadius = 5
        source.layer.cornerRadius = 5
        
        // Spool location service
        getLocation()
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        name.becomeFirstResponder()
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Call into the delegate
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        
        clearErrorMessage()
        
        // Validate the data before saving
        if foodItem == nil {
            setErrorMessage("No food item selected")
            return
        }

        if photo == nil {
            setErrorMessage("Missing photo")
            return
        }
        
        if let newItem = m.foodItem_CreateItem() {
            newItem.name = foodItem!.name
            newItem.source = foodItem!.manu
            newItem.notes = notes.text
            newItem.quantity = Int32(quantity.titleForSegment(at: quantity.selectedSegmentIndex)!)!
            newItem.timestamp = Date()
            newItem.lat = location?.coordinate.latitude ?? 0
            newItem.lon = location?.coordinate.latitude ?? 0
            newItem.location = placemarkText
            
            guard let imageData = UIImageJPEGRepresentation(photo!, 1.0) else {
                setErrorMessage("Cannot save photo")
                return
            }
            newItem.photo = imageData
            
            guard let imageData2 = UIImageJPEGRepresentation(photo!.getThumbnailImage(25.0), 1.0) else {
                setErrorMessage("Cannot save thumbnail photo")
                return
            }
            newItem.photoThumbnail = imageData2
            
            m.ds_save()
        }
        
        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }
 
    @IBAction func pickImage(_ sender: UIButton) {
        pickPhoto()
    }
    
    // MARK: - Private methods
    
    private func getLocation() {
        
        // These two statements setup and configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        
        // Determine whether the app can use location services
        let authStatus = CLLocationManager.authorizationStatus()
        print("Location status: \(authStatus)")
        
        // If the app user has never been asked before, then ask
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // If the app user has previously denied location services, do this
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        // If we are here, it means that we can use location services
        // This statement starts updating its location
        locationManager.startUpdatingLocation()
    }
    
    // Respond to a previously-denied request to use location services
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Build a nice string from a placemark
    // If you want a different format, do it
    private func makePlacemarkText(from placemark: CLPlacemark) -> String {
        var s = ""
        s.append(placemark.subThoroughfare!)
        s.append(" \(placemark.thoroughfare!)")
        s.append(", \(placemark.locality!) \(placemark.administrativeArea!)")
        s.append(", \(placemark.postalCode!) \(placemark.country!)")
        return s
    }
    
    internal func setErrorMessage(_ message: String!) {
        infoBox.text = message
        infoBox.textColor = UIColor.red
    }
    
    internal func clearErrorMessage() {
        infoBox.text = ""
        infoBox.textColor = UIColor.black
    }
    
    // MARK: - Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // When location services is requested for the first time,
        // the app user is asked for permission to use location services
        // After the permission is determined, this method is called by the location manager
        // If the permission is granted, we want to start updating the location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nUnable to use location services: \(error)")
    }
    
    // This is called repeatedly by the iOS runtime,
    // as the location changes and/or the accuracy improves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Here is how you can configure an arbitrary limit to the number of updates
        if locationRequests > 10 { locationManager.stopUpdatingLocation() }
        
        // Save the new location to the class instance variable
        location = locations.last!
        
        // Info to the programmer
        print("\nUpdate successful: \(location!)")
        print("\nLatitude \(location?.coordinate.latitude ?? 0)\nLongitude \(location?.coordinate.longitude ?? 0)")
        
        // Do the reverse geocode task
        // It takes a function as an argument to completionHandler
        geocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            
            // We're looking for a happy response, if so, continue
            if error == nil, let p = placemarks, !p.isEmpty {
                
                // "placemarks" is an array of CLPlacemark objects
                // For most geocoding requests, the array has only one value,
                // so we will use the last (most recent) value
                // Format and save the text from the placemark into the class instance variable
                self.placemarkText = self.makePlacemarkText(from: p.last!)
                // Info to the programmer
                print("\n\(self.placemarkText)")
            }
        })
        
        locationRequests += 1
    }
    
    func selectTaskDidCancel(_ controller: UIViewController) {
        
         dismiss(animated: true, completion: nil)
    }
    
    func selectTask(_ controller: UIViewController, didSelect item: NdbSearchListItem) {
        
        foodItem = item
        
        name.text! = item.name
        source.text! = item.manu
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "FoodItemSearch":
            let vc = segue.destination as! FoodItemSearchList
            vc.delegate = self
            vc.m = m
            vc.searchTerm = name.text!
            break
        default:
            break
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "FoodItemSearch":
            clearErrorMessage()
            if let _x = name.text?.trimmingCharacters(in: .whitespaces).isEmpty, !_x {
                return true
            }
            setErrorMessage("Must enter a food item name")
            return false
        default:
            return true
        }
    }
    
}
