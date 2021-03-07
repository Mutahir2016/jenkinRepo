//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Mutahir on 05/03/2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet var cityLbl : UILabel!
    @IBOutlet var tempLbl : UILabel!
    @IBOutlet var windLbl : UILabel!
    @IBOutlet var tempDescLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
