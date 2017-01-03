//
//  LocationViewController.swift
//  where-are-you
//
//  Created by Takashi Wickes on 1/3/17.
//  Copyright © 2017 takashiw. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var checkUserLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //let locationManager = CLLocationManager()
    let home = CLLocation(latitude: 42.3671143, longitude: -71.1031969)
    let manager = CLLocationManager()
    var isUserHome : Bool!
    
    override func viewDidLoad() {
        manager.delegate = self
        checkButton.isHidden = true;
        manager.requestLocation()
        
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        if(getIsUserHome()){
            checkUserLabel.text = "User is Home"
        } else {
            checkUserLabel.text = "User is NOT Home"
        }
    }
    
    func getIsUserHome() -> Bool {
        return isUserHome
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            checkUserLabel.text = "Location Ready"
            checkButton.isHidden = false
            let distanceFromHome = location.distance(from: home)
            isUserHome = distanceFromHome < 200
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
