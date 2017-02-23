//
//  SoundViewController.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/27/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//
import UIKit
import AVFoundation
import AudioToolbox
class SoundViewController: UITableViewController {
    
    var sounds = ["Paradise", "Hotline Bling Marimba","Loving You", "Soft", "Bells", "Sphere", "Elegant"]
    var musicIndex = Int()
    var songToEdit : String?
    var songToEditIndexPath : Int?
    var selected = ""
    var test : Int?
    weak var delegate : SongDelegate?
    var audioPlayer = AVAudioPlayer()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell")!
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        musicIndex = indexPath.row
        selected = sounds[indexPath.row]
        
        print(musicIndex)
        self.tableView.reloadData()
        play()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if var book = songToEdit {
            book = selected
            delegate?.newSongController(self, didFinishAddingSong: book)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell")!
        cell.textLabel?.text = sounds[indexPath.row]
        if(indexPath.row == musicIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.none;
        }

        return cell
    }
    
    func play () {
        if let asset = NSDataAsset(name: sounds[musicIndex]) {
            do {
                try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                audioPlayer.play()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
