//
//  File.swift
//  WeatherApp
//
//  Created by user193659 on 11/29/21.
//

import Foundation


public class APICaller
{
    
    let city = "Waterloo"
    var lonQuery = "lon="
    var latQuery = "lat="
    var cityQuery = "q="
    var idQuery = "id="
    var finalQuery = "\(WEATHER_BASE_API)"
    var setAny:Bool = false
    
    public init() {
        let apiKey = "appid=4ed8b3219a95396bfd84c91cd6bf9244"
        finalQuery += "\(apiKey)"
    }
    
    public func setLonAndLat(lon:Double,lat:Double)
    {
        finalQuery += "&\(lonQuery)\(lon)&\(latQuery)\(lat)"
        setAny = true
    }
    
    public func setCityName(cityName:String)
    {
        finalQuery += "&\(cityQuery)\(cityName)"
    }
    
    func callApi(completion: @escaping (MyResponse)->())
    {
        if(!setAny)
        {
            setCityName(cityName: city)
        }
        let url = URL(string: finalQuery)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url!, completionHandler: {data,_,error  in
            
            guard let data=data,error==nil else
            {
                print("API Error")
                return
            }
            var apiResponse:MyResponse?
            do{
                let jsonDecoder = JSONDecoder()
                apiResponse = try jsonDecoder.decode(MyResponse.self, from: data)
            }
            catch
            {
                print("Error in Decoding!")
            }
            
            guard let finalData = apiResponse else
            {
                print("Error in data")
                return
            }
            
            completion(finalData)
            
        })
        
        dataTask.resume()
        
    }
    
}

struct Coord:Codable{
    var lon:Double
    var lat:Double
}

struct MyWeather:Codable {
    var main:String
    var icon:String
}

struct MyWind:Codable {
    var speed:Double
}

struct MyTemp : Codable{
    var temp:Double
    var humidity:Int
}

struct MyResponse : Codable {
    var weather:[MyWeather]
    var wind:MyWind
    var main:MyTemp
    var name:String
    var coord:Coord
}

struct coordination : Hashable{
    var lat:Double
    var log:Double
}

