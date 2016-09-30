//
//  MapViewControllerDelegate.swift
//  Bus_Napp
//
//  Created by Charlotte Abrams on 9/26/16.
//  Copyright © 2016 Charlotte Abrams. All rights reserved.
//

import Foundation
import UIKit

protocol MapViewControllerDelegate: class {
    func mapViewController(controller: MapViewController, didPressAddButton latitude: Double, longitude: Double)
}
