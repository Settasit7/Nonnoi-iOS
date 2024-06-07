//
//  ViewController.swift
//  saimai
//
//  Created by Settasit on 21/2/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation
import UserNotifications

class ViewController: UIViewController, GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    var c = 0
    var center = UNUserNotificationCenter.current()
    var cord2D = CLLocationCoordinate2D(latitude: -90, longitude: 0)
    var isAlt = 1
    var isLcn = 0
    var isSch = 0
    var myLo = CLLocationCoordinate2D(latitude: 90, longitude: 0)
    var player: AVAudioPlayer!
    var radius = 0.0
    var track = 0
    @IBOutlet weak var aTitle: UIButton!
    @IBOutlet weak var bTitle: UIButton!
    @IBOutlet weak var cTitle: UIButton!
    @IBOutlet weak var decoy: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtRadius: UITextField! {
        didSet {
            txtRadius.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBAction func aButton(_ sender: Any) {
        if aTitle.backgroundColor == UIColor.white {
            radius = Double(txtRadius.text!) ?? 0.0
            txtRadius.resignFirstResponder()
            if (isSch != 0) && (isLcn != 0) && (radius != 0.0) {
                aTitle.backgroundColor = hexStringToUIColor(hex: "#ff605c")
                mapView.clear()
                marker.map = mapView
                let circle = GMSCircle(position: cord2D, radius: radius * 1000)
                circle.fillColor = UIColor.white.withAlphaComponent(0.5)
                circle.strokeWidth = 0
                circle.map = mapView
                isAlt = 0
            }
        }
        else if aTitle.backgroundColor == hexStringToUIColor(hex: "#ff605c") {
            aTitle.backgroundColor = UIColor.white
            mapView.clear()
            marker.map = mapView
        }
    }
    @IBAction func bButton(_ sender: Any) {
        if track == 0 {
            bTitle.backgroundColor = hexStringToUIColor(hex: "#ffbd44")
            textView.text = "1"
            track = 1
        }
        else if track == 1 {
            textView.text = "2"
            track = 2
        }
        else if track == 2 {
            textView.text = "3"
            track = 3
        }
        else if track == 3 {
            textView.text = "4"
            track = 4
        }
        else if track == 4 {
            textView.text = "5"
            track = 5
        }
        else if track == 5 {
            textView.text = "6"
            track = 6
        }
        else if track == 6 {
            textView.text = "7"
            track = 7
        }
        else if track == 7 {
            textView.text = "8"
            track = 8
        }
        else if track == 8 {
            textView.text = "9"
            track = 9
        }
        else if track == 9 {
            textView.text = "10"
            track = 10
        }
        else if track == 10 {
            bTitle.backgroundColor = UIColor.white
            textView.text = "-"
            track = 0
        }
    }
    @IBAction func cButton(_ sender: Any) {
        if cTitle.backgroundColor == UIColor.white {
            cTitle.backgroundColor = hexStringToUIColor(hex: "#00ca4e")
            mapView.mapType = .normal
        }
        else if cTitle.backgroundColor == hexStringToUIColor(hex: "#00ca4e") {
            cTitle.backgroundColor = UIColor.white
            mapView.mapType = .hybrid
        }
    }
    @IBAction func locationTapped(_ sender: Any) {
        goToPlaces()
    }
    @IBAction func txtRadius(_ sender: Any) {
        aTitle.backgroundColor = UIColor.white
        mapView.clear()
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aTitle.backgroundColor = UIColor.white
        aTitle.layer.cornerRadius = aTitle.bounds.height / 2
        aTitle.layer.masksToBounds = false
        bTitle.backgroundColor = hexStringToUIColor(hex: "#ffbd44")
        bTitle.layer.cornerRadius = bTitle.bounds.height / 2
        bTitle.layer.masksToBounds = false
        bTitle.layer.shadowColor = UIColor.black.cgColor
        bTitle.layer.shadowOpacity = 0.5
        bTitle.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        cTitle.backgroundColor = hexStringToUIColor(hex: "#00ca4e")
        cTitle.layer.cornerRadius = cTitle.bounds.height / 2
        cTitle.layer.masksToBounds = false
        cTitle.layer.shadowColor = UIColor.black.cgColor
        cTitle.layer.shadowOpacity = 0.5
        cTitle.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        decoy.backgroundColor = UIColor.white
        decoy.layer.cornerRadius = decoy.bounds.height / 2
        decoy.layer.masksToBounds = false
        decoy.layer.shadowColor = UIColor.black.cgColor
        decoy.layer.shadowOpacity = 0.5
        decoy.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = false
        textView.backgroundColor = UIColor.clear
        txtSearch.layer.backgroundColor = UIColor.white.cgColor
        txtSearch.layer.cornerRadius = txtSearch.bounds.height / 2
        txtSearch.layer.masksToBounds = false
        txtSearch.layer.shadowColor = UIColor.black.cgColor
        txtSearch.layer.shadowOpacity = 0.5
        txtSearch.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        txtSearch.attributedPlaceholder = NSAttributedString(
            string: "    Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        txtRadius.textColor = UIColor.darkGray
        txtRadius.layer.backgroundColor = UIColor.white.cgColor
        txtRadius.attributedPlaceholder = NSAttributedString(
            string: "Radius (km)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        bButton(self)
        getCurrentLocation()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
        GMSServices.provideAPIKey("***************************************")
        let cord = CLLocationCoordinate2D(latitude: 13.7649, longitude: 100.5383)
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord, zoom: 4)
        do {
            if let styleUrl = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleUrl)
            } else {
                NSLog("404")
            }
        } catch {
            NSLog("Error")
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func getCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            isLcn = 1
        }
    }
    func goToPlaces() {
        txtSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @objc func doneButtonTappedForMyNumericTextField() {
        txtRadius.resignFirstResponder()
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.mapView.clear()
        cord2D = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        aTitle.backgroundColor = UIColor.white
        marker.map = self.mapView
        marker.position = cord2D
        marker.isDraggable = true
        let newCameraPosition = GMSCameraPosition.camera(withTarget: cord2D, zoom: 16)
        mapView.animate(to: newCameraPosition)
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      dismiss(animated: true, completion: nil)
      self.mapView.clear()
      self.txtSearch.text = "    " + (place.name ?? " ")
      cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
      aTitle.backgroundColor = UIColor.white
      marker.map = self.mapView
      marker.position = cord2D
      marker.isDraggable = true
      let newCameraPosition = GMSCameraPosition.camera(withTarget: cord2D, zoom: 16)
      mapView.animate(to: newCameraPosition)
      isSch = 1
  }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
    }
}
extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        if let location = locations.last {
            let lat0 = location.coordinate.latitude
            let lng0 = location.coordinate.longitude
            myLo = CLLocationCoordinate2D(latitude: lat0, longitude: lng0)
            if (c == 0) {
                let newCameraPosition = GMSCameraPosition.camera(withTarget: myLo, zoom: 16)
                mapView.animate(to: newCameraPosition)
                c = 1
            }
            if aTitle.backgroundColor != UIColor.white {
                if isAlt == 0 {
                    if myLo.distance(from: cord2D) <= radius * 1000 {
                        var content = UNMutableNotificationContent()
                        if track == 0 {
                            content.title = "Woof!"
                            content.body = "Arrived!"
                            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "default"))
                        }
                        else {
                            content.title = "Woof!"
                            content.body = "Arrived!"
                            if track == 1 {
                                let url = Bundle.main.url(forResource: "firstdate", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 2 {
                                let url = Bundle.main.url(forResource: "thegirlihaveacrushon", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 3 {
                                let url = Bundle.main.url(forResource: "florence", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 4 {
                                let url = Bundle.main.url(forResource: "blossoms", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 5 {
                                let url = Bundle.main.url(forResource: "bingsoo", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 6 {
                                let url = Bundle.main.url(forResource: "luvletters", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 7 {
                                let url = Bundle.main.url(forResource: "youmakemesmile", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 8 {
                                let url = Bundle.main.url(forResource: "chyeah", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 9 {
                                let url = Bundle.main.url(forResource: "shoreline", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            else if track == 10 {
                                let url = Bundle.main.url(forResource: "withyou", withExtension: "mp3")
                                player = try! AVAudioPlayer(contentsOf: url!)
                            }
                            let session = AVAudioSession.sharedInstance()
                            do {
                                try session.setCategory(AVAudioSession.Category.playback)
                            }
                            catch {}
                            player.play()
                        }
                        let date = Date().addingTimeInterval(3)
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        let uuidString = UUID().uuidString
                        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                        center.add(request)
                        aTitle.backgroundColor = UIColor.white
                        isAlt = 1
                    }
                }
            }
            else if aTitle.backgroundColor == UIColor.white {
                isAlt = 1
            }
        }
    }
}
