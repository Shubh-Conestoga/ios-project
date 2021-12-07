//
//  CitiesDataViewController.swift
//  WeatherApp
//
//  Created by user193659 on 11/29/21.
//

import UIKit

//TABLE AND CORE DATA
class CitiesDataViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var cituTableView: UITableView!
    //context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //cityCore's list
    var cityData : [CityCore]? = []
    //temp list
    var temp : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting data source and delegate
        cituTableView.dataSource = self
        cituTableView.delegate = self
        //fetching data from core
        fetchCitiesData()
    }
    
    //whenever this view controller appear this methods will be called and reload the data
    override func viewWillAppear(_ animated: Bool) {
        fetchCitiesData()
    }
    
    func fetchCitiesData()
    {
        //fetching all core data for citycore and setting the received data to cityData list
        do{
            self.cityData = try context.fetch(CityCore.fetchRequest())
        }
        catch{
            print("Error in fetching city data")
        }
        //reloading the table
        DispatchQueue.main.async {
            self.cituTableView.reloadData()
        }
        
    }
    //return the no of total records of citydata
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData?.count ?? 0
    }
    
    //seeitng the data of each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //getting the reusable cell
        let myCell = tableView.dequeueReusableCell(withIdentifier:"myCell" , for: indexPath) as! CityCell
        //getting the data from cityData using index
        let city = cityData![indexPath.row]
      
        //setting data in cellview
        myCell.cityLabel.text = city.name
        myCell.longitudeLabel.text = "\(city.log)"
        myCell.latitudeLabel.text = "\(city.lat)"
       
        //returning the cell
        return myCell
    }
    

    //can add custom city using this
    @IBAction func AddDataBtnClicked(_ sender: Any) {
        //showing alertcontroller
        let alertController = UIAlertController(title: "Add New Favourite City", message: "Enter Name of city", preferredStyle: .alert)
        //adding texfield
        alertController.addTextField()
        //adding the submit btn alert action
        let submitButton = UIAlertAction(title: "Add", style: .default){
            action in
            let textField = alertController.textFields![0]
            //addingthat city to core data with only name
            if(!textField.text!.isEmpty)
            {
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
            }
            
        }
        
        alertController.addAction(submitButton)
        //adding cancel aition
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //showing the alertcontroller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //delete record
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {
            action,view,comletionHandler in
            
            let city = self.cityData![indexPath.row]
            //deleting the record from context
            self.context.delete(city)
            
            try! self.context.save()
            //reloading the data
            self.fetchCitiesData()
            
        })
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //whenever row gets clicked this method will be called
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //getting the data from cityData using index
        let data = self.cityData![index]
        print("Clicked - \(data.name!)")
        //goting to newxt view controller for showing its weather data in detailas
        let dest = storyboard?.instantiateViewController(withIdentifier:"detailsVC" ) as! CityDataViewController
        print("lat\(data.lat)")
        print("log\(data.log)")
        //setting data for getting weather data from api in next vc
        dest.data = data
        dest.city = data.name

        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    
    
}
