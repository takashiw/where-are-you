//
//  LocationViewController.swift
//  where-are-you
//
//  Created by Takashi Wickes on 1/3/17.
//  Copyright © 2017 takashiw. All rights reserved.
//

import UIKit
import CoreLocation
import Spark_SDK

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var checkUserLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //let locationManager = CLLocationManager()
    var home = CLLocation(latitude: 42.3671143, longitude: -71.1031969)
    let manager = CLLocationManager()
    var isUserHome : Bool!
    var locationText = "Home"
    
    override func viewDidLoad() {
        manager.delegate = self
        checkButton.isHidden = true;
        manager.requestLocation()
        //eventSubscriber()
        backgroundView.backgroundColor = UIColor(red:0.40, green:0.83, blue:1.00, alpha:1.0)
    }
    @IBAction func homePressed(_ sender: Any) {
        manager.requestLocation()
        home = CLLocation(latitude: 42.3671143, longitude: -71.1031969)
        locationText = "Home"
        locationLabel.text = "Loading New Location..."
        backgroundView.backgroundColor = UIColor(red:1.00, green:0.67, blue:0.30, alpha:1.0)

    }
    @IBAction func awayPressed(_ sender: Any) {
        manager.requestLocation()
        home = CLLocation(latitude: 42.3671143, longitude: -1.1031969)
        locationText = "Away"
        locationLabel.text = "Loading New Location..."
        backgroundView.backgroundColor = UIColor(red:1.00, green:0.67, blue:0.30, alpha:1.0)
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        manager.requestLocation()
        if(getIsUserHome()){
            checkUserLabel.text = "User is Home"
            backgroundView.backgroundColor = UIColor(red:0.26, green:0.96, blue:0.47, alpha:1.0)
        } else {
            checkUserLabel.text = "User is NOT Home"
            backgroundView.backgroundColor = UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
        }
    }
    
    func getIsUserHome() -> Bool {
        return isUserHome
    }
    
    func eventSubscriber() {
        SparkCloud.sharedInstance().login(withUser: "ecphylo@gmail.com", password: "ideo123") { (error:Error?) -> Void in
            if let e=error {
                print("Wrong credentials or no internet connectivity, please try again")
            }
            else {
                print("Logged in")
            }
            print("YEET")
        }
        
        var sparky = SparkCloud.sharedInstance().accessToken
        
        
        var subscriberObject: SparkSubscriber = SparkSubscriber()
        subscriberObject.subscribe()
        var handler : Any?
        handler = SparkCloud.sharedInstance().subscribeToAllEvents(withPrefix: "colabsecurity", handler: { (event :SparkEvent?, error : Error?) in
            if let _ = error {
                print ("could not subscribe to events")
            } else {
                DispatchQueue.main.async(execute: {
                    print("got event with data \(event?.data)")
                })
            }
        })
        
        var eventListenerID : Any?
        eventListenerID = SparkCloud.sharedInstance().subscribeToMyDevicesEvents(withPrefix: "colabsecurity", handler: handler as! SparkEventHandler?)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            checkUserLabel.text = "Location Ready"
            locationLabel.text = locationText
            backgroundView.backgroundColor = UIColor(red:0.40, green:0.83, blue:1.00, alpha:1.0)
            checkButton.isHidden = false
            let distanceFromHome = location.distance(from: home)
            print(home)
            print(distanceFromHome)
            distanceLabel.text = "Distance: \(distanceFromHome)"
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
