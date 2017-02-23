//
//  NewBusViewController.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/26/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class NewBusViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, SongDelegate {
    @IBOutlet weak var SongCell: UITableViewCell!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    var latitude: Double?
    var longitude: Double?
    var songForLabel: String?
    var textForLabel: String?
    var locationToEdit: Location?
    var songName: String?
    var locationToEditIndexPath: Int?
     var sounds = ["Paradise", "Hotline Bling Marimba","Loving You", "Soft", "Bells", "Sphere", "Elegant"]


    @IBOutlet weak var distancePicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textSegue" {
            let songController = segue.destination as! SoundViewController
            songController.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            songController.songToEdit = sounds[indexPath.row]
            songController.songToEditIndexPath = indexPath.row
            }
           
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "textSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    func newSongController(_ controller: SoundViewController, didFinishAddingSong name: String) {
        songName = name
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var delegate: LocationDetailsControllerDelegate?

    
    var distance = 1
    
//    var locationToSave: Location?   ????????????
    
    var possibleDistances = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], [".0 mi", ".25 mi", ".5 mi", ".75 mi"]]
    var finalDistance = 0.0
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let location = locationToEdit {
            location.song = songName
            print("THIS IS SONG NAME", songName)
            print(location.song, " location song name")
            location.name = nameTextField.text
            location.latitude = (locationToEdit?.latitude)!
            location.longitude = (locationToEdit?.longitude)!
            location.distance = finalDistance
            location.activated = (locationToEdit?.activated)!
            saveLocation()
            delegate?.newBusViewController(self, didFinishEditingLocation: location)
            dismiss(animated: true, completion: nil)
        } else {
            let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedObjectContext) as! Location
            newLocation.distance = finalDistance
            if nameTextField.text == "" {
                newLocation.name = "Bus Stop"
            } else {
                newLocation.name = nameTextField.text
            }
            newLocation.song = songName
            newLocation.latitude = latitude!
            newLocation.longitude = longitude!
            newLocation.activated = true
            saveLocation()
            dismiss(animated: true, completion: nil)
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 1
        }
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
   
    
//    let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
//    var tabBarController = appDelegate.window!.rootViewController as! UITabBarController
//    tabBarController.selectedIndex = 1
//    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return possibleDistances.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleDistances[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleDistances[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = distancePicker.selectedRow(inComponent: 0)
        let dec = Double(distancePicker.selectedRow(inComponent: 1))/4
        let total = Double(value) + dec
        finalDistance = total
        print (finalDistance, "final distance")
    }
    override func viewDidAppear(_ animated: Bool) {
        if var location = locationToEdit {
            if songName == nil {
                SongCell.detailTextLabel!.text = songForLabel
            } else {
                SongCell.detailTextLabel!.text = songName
            }
        } else {
            if songName == nil {
                SongCell.detailTextLabel!.text = "Paradise"
            } else {
                SongCell.detailTextLabel!.text = songName
            }
        }
    }
    override func viewDidLoad() {
        if var location = locationToEdit {
            if songName == nil {
                SongCell.detailTextLabel!.text = songForLabel
            } else {
                SongCell.detailTextLabel!.text = songName
            }
        } else {
            if songName == nil {
                SongCell.detailTextLabel!.text = "Paradise"
            } else {
                SongCell.detailTextLabel!.text = songName
            }
        }
        nameTextField.text = textForLabel
        distancePicker.dataSource = self
        distancePicker.delegate = self
        nameTextField.attributedPlaceholder = NSAttributedString(string: "ex: work, home", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        super.viewDidLoad()
    }
}
