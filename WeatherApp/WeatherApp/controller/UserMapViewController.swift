//
//  UserMapViewController.swift
//  WeatherApp
//
//  Created by user199008 on 11/30/21.
//

import UIKit
import MapKit

//Map
class UserMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //seting the context for coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //creating object of locationmanager
    let manager = CLLocationManager()
    //creating dict and list
    var locationWeatherDict : [coordination:MyResponse] = [:]
    var locationPinned:[coordination] = []
    var annotations : [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning datasource and delegate to self
        manager.delegate = self
        mapView.delegate = self
        //asking for permission
        manager.requestWhenInUseAuthorization()
        //getting the location using best accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //start updating the location
        manager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    //location of user update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //getting the initial location of user
        if let location = locations.first
        {
            //stop updating user's locaiton
            manager.stopUpdatingLocation()
            showLatestLocation(location)
        }
        showLatestLocation(locations.first!)
    }
    func showLatestLocation(_ latestLocation:CLLocation)
    {
        //geting the user's coordinates span and the creating the regin
        let coord = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
       
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coord, span: span)
        //setting region to mapview
        mapView.setRegion(region, animated: true)
        
    }
    
    //for custom annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        //taking the coordinates from the annotation/pin
        let lat = annotation.coordinate.latitude
        let log = annotation.coordinate.longitude
        let coord = coordination(lat: lat, log: log)
        //getting weather data of that pin using openweather api
        if let apiResponse = locationWeatherDict[coord]
        {
            //using reusable view for pin
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            let url = URL(string: "\(WEATHER_ICON_API)\(apiResponse.weather.first?.icon ?? "10d").png")
            //setting the pin's image as reponse of weather api's weather icon
            annotationView.image = try! UIImage(data: Data(contentsOf: url! ))
            // to trun on showing api dtls on click on pin
            annotationView.canShowCallout = true
            return annotationView
        }
            return nil
        }
    
    //will be called when user change the map or explore map by swiping
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    
        let coord = mapView.centerCoordinate
        let hashCoord : coordination = coordination(lat: coord.latitude, log: coord.longitude)
        //checking is visible mapview has any annotation
        if(mapView.annotations(in: mapView.visibleMapRect).count<=0)
        {
            let apiCall = APICaller()
            //calling weather api for getting the data
            apiCall.setLonAndLat(lon: coord.longitude, lat: coord.latitude)
            apiCall.callApi(completion: {data in
//                guard let _:MyResponse? = data else
//                {
//                    return
//                }
                //adding weather data to dict
                self.locationWeatherDict[hashCoord] = data
                //also adding pin this locaiton in mapview
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
                //getting the coord
                pin.coordinate = CLLocationCoordinate2D(latitude: weather.key.lat, longitude: weather.key.log)
                //setting pin's title and subtitle to place name and weather data
                pin.title = weather.value.name
                pin.subtitle = "\(weather.value.weather.first!.main) Temp : \(weather.value.main.temp) \u{00b0}" 
                mapView.addAnnotation(pin)
                //adding this pin to list
                annotations.append(pin)
            }
        }
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        
        let visibleRect = mapView.visibleMapRect
        let annots = mapView.annotations(in: visibleRect)
        for annot in annots
        {
           let point = annot as! MKPointAnnotation
            let coord = coordination(lat: point.coordinate.latitude, log: point.coordinate.longitude)
            //if find any weather data for given coord
            if let apiResponse = locationWeatherDict[coord]
            {
                //adding that coord to core data
                DispatchQueue.main.async {
                    let city = CityCore(context: self.context)
                    city.lat = apiResponse.coord.lat
                    city.name = apiResponse.name
                    city.log = apiResponse.coord.lon
                    
                    try! self.context.save()
                }
            }
            
            
        }
            
        
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}
