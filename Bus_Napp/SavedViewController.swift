//
//  SavedViewController.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/26/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SavedViewController: UITableViewController, LocationDetailsControllerDelegate, CancelButtonDelegate {
    
    var locations = [Location]()
    var song: String?
    var notifSong : String?
    var locationToEdit: Location?
   
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func cancelButtonPressedFrom(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllLocations()
        self.tableView.reloadData()
        for x in locations {
            print("song", x.song)
            print("name", x.name)
            print("distance", x.distance)
            print("lat", x.latitude)
            print("long", x.longitude)
        }
       
    }


    
    func fetchAllLocations() {
        let userRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedObjectContext.fetch(userRequest)
            locations = results as! [Location]
        } catch {
            print ("\(error)")
        }
    }
    
    func newBusViewController(_ controller: NewBusViewController, didFinishAddingLocation name: String) {
        print("hey")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editLocation" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! NewBusViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.locationToEdit = locations[indexPath.row]
                controller.locationToEditIndexPath = indexPath.row
                controller.textForLabel = locations[indexPath.row].name
                controller.songForLabel = locations[indexPath.row].song
            }
        }
    }
    
    func newBusViewController(_ controller: NewBusViewController, didFinishEditingLocation location: Location) {
        location.distance = controller.finalDistance
        location.name = controller.nameTextField.text
        location.song = controller.SongCell.detailTextLabel?.text
        print ("AHHHHHHHH")
        saveLocation()
        fetchAllLocations()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        cell.textLabel?.text = locations[indexPath.row].name
         let switchView: UISwitch = UISwitch(frame: CGRect.zero) as UISwitch
        switchView.isOn = false
          cell.accessoryView = switchView
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(SavedViewController.switchTriggered(_:)), for: .valueChanged );
        if locations[indexPath.row].activated == true {
            switchView.isOn = true
        }
        return cell
    }
   
    func switchTriggered(_ sender: UISwitch) {
        if sender.isOn == true {
            locations[sender.tag].activated = true
            if notifSong == nil {
                notifSong = "Paradise"
                saveLocation()
            } else {
                notifSong = locations[sender.tag].song
            }
            if locations[sender.tag].distance == 0 {
                locations[sender.tag].distance = 0.25
                saveLocation()
            }
            saveLocation()
        } else {
            locations[sender.tag].activated = false
            saveLocation()
        }
    }

    var selectedRow = Int()
    var option = Location()

//    override func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell")!
//        selectedRow = indexPath.row
//        print(selectedRow)
//       
//        self.tableView.reloadData()
//        
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let test = locations.remove(at: indexPath.row)
        self.managedObjectContext.delete(test)
        do {
            try managedObjectContext.save()
            print ("Success")
        } catch {
            print("\(error)")
        }
        fetchAllLocations()
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        UISwitch.appearance().onTintColor = UIColor(red: 35/255, green: 183/255, blue: 166/255, alpha: 1.0)
        super.viewDidLoad()
        fetchAllLocations()
        self.tableView.reloadData()
       
    }
}
