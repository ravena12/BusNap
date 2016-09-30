//
//  LocationDetailsControllerDelegate.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/27/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import Foundation
import UIKit

protocol LocationDetailsControllerDelegate: class {
    
    func newBusViewController(controller: NewBusViewController, didFinishAddingLocation name: String)
    func newBusViewController(controller: NewBusViewController, didFinishEditingLocation location: Location)
}