//
//  UserMapViewController.swift
//  WeatherApp
//
//  Created by user193659 on 11/30/21.
//

import UIKit
import MapKit

class UserMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    var locationWeatherDict : [coordination:MyResponse] = [:]
    var locationPinned:[coordination] = []
    var annotations : [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            manager.stopUpdatingLocation()
            showLatestLocation(location)
        }
    }
    func showLatestLocation(_ latestLocation:CLLocation)
    {
        let coord = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
       
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    
        let coord = mapView.centerCoordinate
        let hashCoord : coordination = coordination(lat: coord.latitude, log: coord.longitude)
        if(mapView.annotations(in: mapView.visibleMapRect).count<=0)
        {
            let apiCall = APICaller()
            apiCall.setLonAndLat(lon: coord.longitude, lat: coord.latitude)
            apiCall.callApi(completion: {data in
                guard let _:MyResponse? = data else
                {
                    return
                }
                self.locationWeatherDict[hashCoord] = data
                self.pinThisLocation()
            
            } )
           
        }
            
    }
    
    func pinThisLocation()
    {
        for weather in locationWeatherDict
        {
            if(!locationPinned.contains(weather.key) && mapView.annotations(in: mapView.visibleMapRect).count<=0)
            {
                locationPinned.append(weather.key)
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: weather.key.lat, longitude: weather.key.log)
                pin.title = weather.value.weather.first?.main
                mapView.addAnnotation(pin)
                annotations.append(pin)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}
