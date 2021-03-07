//
//  WeatherInfoTableViewCell.swift
//  WeatherApp
//
//  Created by Mutahir on 05/03/2021.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {

    @IBOutlet var hourLbl : UILabel!
    @IBOutlet var tempLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
