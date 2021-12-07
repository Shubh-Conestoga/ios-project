//
//  File.swift
//  WeatherApp
//
//  Created by user193659 on 11/29/21.
//

import Foundation

//Api calller
public class APICaller
{
    
    let city = "Waterloo"
    var lonQuery = "lon="
    var latQuery = "lat="
    var cityQuery = "q="
    var idQuery = "id="
    var finalQuery = "\(WEATHER_BASE_API)"
    var setAny:Bool = false
    //building this using builder patter
    //constructor
    public init() {
        //setting api key in finalquery
        let apiKey = "appid=4ed8b3219a95396bfd84c91cd6bf9244"
        finalQuery += "\(apiKey)"
    }
    
    public func setLonAndLat(lon:Double,lat:Double)
    {
        //setting log and lat in final query
        finalQuery += "&\(lonQuery)\(lon)&\(latQuery)\(lat)"
        setAny = true
    }
    
    public func setCityName(cityName:String)
    {
        //setting city in final query
        finalQuery += "&\(cityQuery)\(cityName)"
        setAny = true
    }
    
    func callApi(completion: @escaping (MyResponse)->())
    {
        //if nothing is set then by default get data of waterloo city
        if(!setAny)
        {
            setCityName(cityName: city)
        }
        //appending units as metric for data in C
        finalQuery.append("&units=metric")
        //making ur
        let url = URL(string: finalQuery)
        print(finalQuery)
        //creating default session
        let session = URLSession(configuration: .default)
        //creating the data task
        let dataTask = session.dataTask(with: url!, completionHandler: {data,_,error  in
            //checking if result has error or not
            guard let data=data,error==nil else
            {
                print("API Error")
                return
            }
            var apiResponse:MyResponse?
            do{
                let jsonDecoder = JSONDecoder()
                //decoding json data to MyResponse struct type
                apiResponse = try jsonDecoder.decode(MyResponse.self, from: data)
            }
            catch
            {
                print("Error in Decoding!")
            }
            //if apiResponse is not null then calling completion closure and sending response in its parameter
            guard let finalData = apiResponse else
            {
                print("Error in data")
                return
            }
            
            completion(finalData)
            
        })
        //resuming the data task
        dataTask.resume()
        
    }
    
}
//structure for getting and decoding the api response
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
//for adding this structure as key in dict
struct coordination : Hashable{
    var lat:Double
    var log:Double
}

