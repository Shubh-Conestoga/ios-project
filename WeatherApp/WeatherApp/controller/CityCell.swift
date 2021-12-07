//
//  CityCell.swift
//  WeatherApp
//
//  Created by user193659 on 12/1/21.
//

import UIKit

//tabel cell custom view
class CityCell: UITableViewCell {


    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
