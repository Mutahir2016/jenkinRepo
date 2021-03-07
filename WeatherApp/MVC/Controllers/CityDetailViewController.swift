//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Mutahir on 05/03/2021.
//

import UIKit

public class CityDetailViewController: UIViewController {
    
    @IBOutlet var cityNameLbl : UILabel!
    @IBOutlet var tableview : UITableView!
    
    var cityWeatherInfoList = CityWeatherClass()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UIViewController.displaySpinner(onView: self.view)
        
        cityNameLbl.text = LocationManager.shared.currentLocInfo.city
        let api = String(format: ApiManager.weatherInfo5DaysByCityName, LocationManager.shared.currentLocInfo.city)
        ApiManager.requestFromServerFor(callName: api, apiMethod: .GET, parameter: [:]) { (bSuccess, response, error) in
            //
            UIViewController.removeSpinner()
            
            if bSuccess
            {
                self.cityWeatherInfoList = CityWeatherClass(json: response)
                
                DispatchQueue.main.async {
                    //
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    @IBAction func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
}

//***************************************************************************//
//MARK:- table view methods
//***************************************************************************//

extension CityDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return cityWeatherInfoList.weatherDaysInfo.count
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    /*************************************************************/
    //Set header to show Days
    /*************************************************************/

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        
        headerView.backgroundColor = .groupTableViewBackground
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        label.text = cityWeatherInfoList.weatherDaysInfo[section].dateString
        headerView.addSubview(label)
        return headerView
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 2))
        headerView.backgroundColor = .groupTableViewBackground
        return headerView
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return cityWeatherInfoList.weatherDaysInfo[section].hoursList.count
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoTableViewCell") as! WeatherInfoTableViewCell
        cell.selectionStyle = .none
        
        let value = cityWeatherInfoList.weatherDaysInfo[indexPath.section].hoursList[indexPath.row]
        
        cell.hourLbl.text = value.hourValue
        cell.tempLbl.text = value.tempValue + "°"
        
        return cell
    }
    
    /*************************************************************/
    //
    /*************************************************************/

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
}
