//
//  SongDelegate.swift
//  Bus_Napp
//
//  Created by Raven Anderson on 9/27/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import Foundation

import UIKit

protocol SongDelegate: class {
    
    func newSongController(controller: SoundViewController, didFinishAddingSong book: String)
}