//
//  CityDataViewController.swift
//  WeatherApp
//
//  Created by user193659 on 12/6/21.
//

import UIKit

class CityDataViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherlabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    var data:CityCore? = nil
    var city:String? = nil
    
    @IBOutlet weak var activityBar: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.isHidden = true
        imageView.isHidden = true
        degreeLabel.isHidden = true
        activityBar.startAnimating()
        
        let api = APICaller()
        if data?.log == nil && data?.lat == nil && data?.log == 0 && data?.lat == 0
        {
            api.setLonAndLat(lon: data!.log, lat: data!.lat)
        }
        else
        {
            let myCity = city ?? "Waterloo"
            api.setCityName(cityName: myCity)
        }
        
        api.callApi(completion: {result in
            DispatchQueue.main.async {
                self.activityBar.stopAnimating()
                self.activityBar.isHidden = true
                self.cityLabel.isHidden = false
                self.degreeLabel.isHidden = false
                self.imageView.isHidden = false
                
                self.weatherlabel.text = result.weather.first?.main
                self.windLabel.text = String(format:"%.2f",result.wind.speed)
                self.humidityLabel.text = "\(result.main.humidity)%"
                
                self.cityLabel.text = self.city
                print("\(String(format: "%.2f",(result.main.temp)))\u{00b0}")
                self.degreeLabel.text = "\(String(format: "%.2f",(result.main.temp)))\u{00b0}"
                print("\(String(format: "%0.2f", result.main.temp))")
                let url = URL(string: "\(WEATHER_ICON_API)\(result.weather.first!.icon).png")
                print("filterusingthis \(url!.absoluteURL)")
                let data = try? Data(contentsOf: url!)
                self.imageView.image = UIImage(data: data!)
            }
        })
        
    }
    
   
}
