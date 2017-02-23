//
//  ViewController.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/26/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import CoreData
import AudioToolbox
import AVFoundation

class MapViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate, CancelButtonDelegate  {
    
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var switchO: UISwitch!
   
    var busImage: UIImage?
    var locations2 = [Location]()
     var audioPlayer = AVAudioPlayer()
    var notifSong = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
//    var anotation = MKPointAnnotation()
//        anotation.coordinate = location
//        anotation.title = "The Location"
//        anotation.subtitle = "This is the location !!!"
//        myMap.addAnnotation(anotation)
    
    
    
    let locationManager = CLLocationManager()
    var delegate: MapViewControllerDelegate?
    var longitude = Double()
    var latitude = Double()
//    var name = String()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        longitude = (view.annotation?.coordinate.longitude)!
        latitude = (view.annotation?.coordinate.latitude)!
    }
    
    func placeItemOnMap(_ item: MKMapItem) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = item.placemark.coordinate
        annotation.title = item.name
        mapView.addAnnotation(annotation)
    }

    func search() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "bus stop"
        request.region = mapView.region
        
        let search = MKLocalSearch (request: request)
        search.start(completionHandler: {
            response, error in
            if error != nil {
            } else {
                if let mapItems = response?.mapItems {
                    for item in mapItems {
                        self.placeItemOnMap(item)
                    }
                }
            }
        })
    }
    
    func newBusViewController(_ controller: NewBusViewController, didFinishAddingLocation name: String) {
        print("hey")
    }
    func newBusViewController(_ controller: NewBusViewController, didFinishEditingLocation name: String) {
        print("hey2")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllLocations()
         UITabBar.appearance().barTintColor = UIColor(red: 35/255, green: 183/255, blue: 166/255, alpha: 1.0)
        dLabel.layer.borderWidth = 0.5
        dLabel.layer.borderColor = UIColor.black.cgColor
        
        let image = UIImage(named: "bus")?.cgImage
        busImage = UIImage(cgImage: image!, scale: 4.0, orientation: UIImageOrientation(rawValue: 1)!)
        switchO.layer.cornerRadius = 16 
        mapView.delegate = self
        self.mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotation(_:)))
//        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if counter < 1 {
//            center(locations)
//        }
//        myLocation = locations.last!
//        search()
//    }
    
    var startLocation:CLLocation!
    var lastLocation = CLLocation()
    var check3: Bool?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first!
             center(locations)
        }
        lastLocation = locations.last!
        if tracker == true {
            center(locations)
        }
        fetchactivated()
        search()
        math()
        fetchAllLocations()
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("App in Background")
            check3 = false
        }
        if state == .active {
            print("App is active!")
            print(check3)
            check3 = true
        }
       view.setNeedsDisplay()

    }
    
    var tracker: Bool?
    
    @IBAction func trackerButtonPressed(_ sender: UISwitch) {
        if sender.isOn == true {
            print(true)
            tracker = true
        } else {
            tracker = false
            print(false)
        }
        
    }
    
    
    var destinationLa = Double()
    var destinationLo = Double()
    var test = CLLocation()
    var d = Double()
    var songplay = 0
    var so = ""
    
    func set () {
        for item in self.locations2 {
            if item.activated == true {
                item.activated = false
                self.destinationLa = 0.0
                self.destinationLo = 0.0
                self.saveLocation()
                self.notifSong = item.song!
                self.songplay = 0
            }
        }

        
    }
    
    func check() {
        if songplay == 1 && check3 == true {
            play()
            let alertController = UIAlertController(title: "Alarm!", message: "Wake Up!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                print("OK Pressed")
                self.set()
                self.audioPlayer.stop()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if songplay == 1 && check3 == false {
            let pushTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MapViewController.pushNotification), userInfo: nil, repeats: false)
            self.set()
        }
        }
    func fetchactivated() {
        for item in locations2 {
            if item.activated == true {
               destinationLa = item.latitude
                destinationLo = item.longitude
                if item.song == nil {
                    so = "Paradise"
                    item.song = "Paradise"
                    saveLocation()
                } else {
                    so = item.song!
                }
                if item.distance == 0 {
                    item.distance = 0.25
                    saveLocation()
                }
                if item.distance > d {
                    songplay += 1
                    check()
                    print("WAKE UP WAKE UP WAKE UP ")
//                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            print(item.activated, "ACTIVATED??")
        }
        test = CLLocation(latitude: destinationLa, longitude: destinationLo)
    }
    
    func play() {
        print(so)
            if let asset = NSDataAsset(name: so) {
                do {
                    try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
         AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
        func math () {
        let distance = lastLocation.distance(from: test) * 0.000621371
        print(distance, "DISTANCE FROM BUS ")
            for item in locations2 {
                if item.activated == true {
                     dLabel.text = "You are " + String(round(100*distance)/100) + " miles away from your destination"
                    print(dLabel.text, "LABEL TEXT LABEL TEXT")
                } else {
                    dLabel.text? = ""
                }
            }
             d = distance
    }
    
    func saveLocation() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print ("Success")
            } catch {
                print ("\(error)")
            }
        }
    }
    
    func fetchAllLocations() {
        let userRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedObjectContext.fetch(userRequest) as! [Location]
            locations2 = results
            print(locations2)
        } catch {
            print("\(error)")
        }
    }

    var counter = Int()
    func center(_ locations : [CLLocation]) {
        counter += 1
        let location = locations.first
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }

    
    func addAnnotation(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        //Add Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New Bus Stop"
        mapView.addAnnotation(annotation)
    }
    
 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            return nil
        } else {
        view.image = busImage
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.contactAdd)
             return view
        }
        
//        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.contactAdd {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegue(withIdentifier: "addLocation", sender: view)
        }
    }
    
    func cancelButtonPressedFrom(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! NewBusViewController
            controller.latitude = latitude
            controller.longitude = longitude
//            print (latitude, "LATITUDE")
//            print (longitude, "LONGITUDE")
//            controller.location = sender as! Location
            controller.cancelButtonDelegate = self
        }
    }
    func someFunction(_ delta: Int) {
        if delta < 100 {
            // Send alert to user if app is open
            let alertView = UIAlertController(title: "This is an Alert!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            
            // Send user a local notification if they have the app running in the bg
           let pushTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MapViewController.pushNotification), userInfo: nil, repeats: false)
        }
    }
    
    // Send user a local notification if they have the app running in the bg
    func pushNotification() {
        let notification = UILocalNotification()
        notification.alertAction = "Go back to App"
        notification.alertBody = "Wake Up! Your Bus Stop is Approaching!"
        notification.fireDate = Date(timeIntervalSinceNow: 1)
        notification.applicationIconBadgeNumber = 1;
        notification.soundName  = notifSong + ".wav"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    

    
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        //I don't know how to convert this if condition to swift 1.2 but you can remove it since you don't have any other button in the annotation view
//        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
//            mapView.deselectAnnotation(view.annotation, animated: false)
//            performSegueWithIdentifier("you're segue Id to detail vc", sender: view)
//        }
//    }

}




//extension MapViewController:  {
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//    
//    
//
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("error:: \(error)")
//    }
//}
