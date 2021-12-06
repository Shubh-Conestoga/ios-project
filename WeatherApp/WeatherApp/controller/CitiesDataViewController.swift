//
//  CitiesDataViewController.swift
//  WeatherApp
//
//  Created by user193659 on 12/1/21.
//

import UIKit

class CitiesDataViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var cituTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cityData : [CityCore]? = []
    
    var temp : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cituTableView.dataSource = self
        cituTableView.delegate = self
        fetchCitiesData()
        fetchAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCitiesData()
    }
    
    func fetchCitiesData()
    {
        do{
            self.cityData = try context.fetch(CityCore.fetchRequest())
        }
        catch{
            print("Error in fetching city data")
        }
        
        DispatchQueue.main.async {
            self.cituTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier:"myCell" , for: indexPath) as! CityCell
        let city = cityData![indexPath.row]
      
        myCell.cityLabel.text = city.name
        myCell.longitudeLabel.text = "\(city.log)"
        myCell.latitudeLabel.text = "\(city.lat)"
       
        return myCell
    }
    

    @IBAction func AddDataBtnClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Favourite City", message: "Enter Name of city", preferredStyle: .alert)
        alertController.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default){
            action in
            let textField = alertController.textFields![0]
            
            let newCity = CityCore(context: self.context)
            newCity.name = textField.text
            newCity.url = "URL"
            
            do{
                try self.context.save()
            }
            catch{
                print("Error in saving the data")
            }
            
            self.fetchCitiesData()
            self.fetchAPIData()
            
        }
        
        alertController.addAction(submitButton)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //delete record
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {
            action,view,comletionHandler in
            
            let city = self.cityData![indexPath.row]
            
            self.context.delete(city)
            
            try! self.context.save()
            
            self.fetchCitiesData()
            
        })
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func fetchAPIData()
    {
        
        
        for city in self.cityData!
        {
            let apiCaller = APICaller()
            apiCaller.setCityName(cityName: city.name!)
            
            apiCaller.callApi()
            {
                response in
                city.temp=response.main.temp
                print("\(String(city.name!)) \(response.main.temp)")
            }
        }
        
        DispatchQueue.main.async {
            self.cituTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = self.cityData![index]
        print("Clicked - \(data.name!)")
        let dest = storyboard?.instantiateViewController(withIdentifier:"detailsVC" ) as! CityDataViewController
        
        dest.data = data
        dest.city = data.name
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    
    
}
