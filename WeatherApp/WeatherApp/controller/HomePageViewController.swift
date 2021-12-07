//
//  HomePageViewController.swift
//  WeatherApp
//
//  Created by user193659 on 12/6/21.
//

import UIKit
import MapKit

class HomePageViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManagaer = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hinding value untill the response come and showing activity circle
        placeName.isHidden = true
        imageView.isHidden = true
        tempLabel.isHidden = true
        progressView.startAnimating()
        //setting delegate and getting the location with best accuracy and start updating the user locaiton
        locationManagaer.delegate = self
        locationManagaer.desiredAccuracy = kCLLocationAccuracyBest
        locationManagaer.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //getting the user's first location
        if let location = locations.first
        {
            //stop updating the location
            manager.stopUpdatingLocation()
            //getting data from weather api using coord
            GetDataFromCoordinate(coord:location.coordinate)
        }
    }
    
    func GetDataFromCoordinate(coord:CLLocationCoordinate2D)
    {
        //calling api for getting weather data
        let apiCaller = APICaller()
        //setting log and lat of user location for getting api response for user's location
        apiCaller.setLonAndLat(lon: coord.longitude, lat: coord.latitude)
        //setting thr api response
        apiCaller.callApi(completion: {result in
            DispatchQueue.main.async {
                self.placeName.isHidden = false
                self.imageView.isHidden = false
                self.tempLabel.isHidden = false
                self.progressView.isHidden = true
                self.progressView.stopAnimating()
                self.placeName.text = result.name
                self.humidityLabel.text = "\(result.main.humidity)%"
                self.tempLabel.text = "\(String(format:"%0.2f",result.main.temp))"
                self.windLabel.text = "\(String(format:"%0.2f",result.wind.speed))km/h"
                self.weatherLabel.text = result.weather.first?.main
                
                let url = URL(string: "\(WEATHER_ICON_API)\(result.weather.first?.icon ?? "10d").png")
                let data = try? Data(contentsOf: url!)
                self.imageView.image = UIImage(data: data!)
                
            }
        })
    }
    

    

}
