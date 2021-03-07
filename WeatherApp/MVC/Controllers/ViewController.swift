//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mutahir on 04/03/2021.
//

import UIKit
import CCAutocomplete

class ViewController: UIViewController,UITextFieldDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var citySearchField: UITextField!
    var isFirstLoad: Bool = true
    var autoCompleteViewController: AutoCompleteViewController!
    var citiesDataArr : [CitiesList]? = []
    var selectedCitiesList : [SelectedCityDataModel] = []
    var weatherObject : [WeatherDataModel] = []
    @IBOutlet weak var citiesView: UIView!
    @IBOutlet weak var selectedCitiesLbl: UILabel!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesDataArr = getCitiesData()
        
        //Hide view as there are is no selection and set label as empty
        self.citiesView.isHidden = true
        self.selectedCitiesLbl.text = ""
        self.tableView.isHidden = true
        LocationManager.shared.requestUserPermissionsAndStartUpdatingLocation()
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    @IBAction func onClickCurrentCityInfo (_ sender:UIButton)
    {
        if LocationManager.shared.currentLocInfo == nil
        {
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityDetailViewController") as? CityDetailViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.citySearchField
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        let filteredCities = citiesDataArr?.filter { (value) -> Bool in
            value.name.lowercased().contains(term.lowercased())
        }
        
        let citiesList: [AutocompletableOption]? = filteredCities?.map({ (cityValue) -> AutocompleteCellData in
            
            return AutocompleteCellData(cityId: "\(cityValue.id)",
                                        text: cityValue.name,
                                        image: UIImage(named: ""))
        })
        
        return citiesList ?? []
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    func didSelectItem(_ item: AutocompletableOption) {
        setTextFieldFor(selectedObj: item)
    }
    
    /*************************************************************/
    // show selected cities on label as comma separated
    /*************************************************************/
    
    func setTextFieldFor(selectedObj : AutocompletableOption) {
        if selectedCitiesList.count <= 6 {
            var cityName = ""
            let obj = SelectedCityDataModel(cityId: selectedObj.cityId, cityName: selectedObj.text)
            
            if selectedCitiesList.count > 0 && selectedCitiesList.contains(obj) {
                return
            }
            selectedCitiesList.append(obj)
            
            for items in selectedCitiesList {
                if cityName.isEmpty
                {
                    cityName = items.cityName
                }
                else
                {
                    cityName = cityName + ", \(items.cityName)"
                }
            }
            
            DispatchQueue.main.async {
                //set text field as empty to enter new city
                self.citySearchField.text = ""
                //unhide label view as we are expecting city name here
                self.citiesView.isHidden = false
                self.selectedCitiesLbl.text = cityName
            }
        } else {
            self.citySearchField.text = ""
            self.displayAlertMessageWith(title: "Error", messageToDisplay: "You can only enter between 3 to 7 cities")
        }
    }
    
    /*************************************************************/
    //
    /*************************************************************/
    
    @IBAction func onSearchBtnTapped(_ sender: UIButton) {
        
        if selectedCitiesList.count >= 3 && selectedCitiesList.count <= 7 {
            UIViewController.displaySpinner(onView: self.view)
            self.startFetchTemperatureData(index: 0)
        } else {
            self.displayAlertMessageWith(title: "Error", messageToDisplay: "Please enter atleast 3 and atmost 7 cities")
        }
        
    }
}

//***************************************************************************//
//MARK:- table view methods
//***************************************************************************//

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weatherObject.count
    }
    
    //***************************************************************************//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") as! CityTableViewCell
        cell.selectionStyle = .none
        
        let weatherElement = weatherObject[indexPath.row]
        cell.cityLbl.text = weatherElement.name
        
        var minTemp = ""
        var maxTemp = ""
        var winSpeed = ""
        
        if let minT = weatherElement.main.tempMin {
            minTemp = String(format: "%.0f", minT - 273.15)
        }
        
        if let maxT = weatherElement.main.tempMax {
            maxTemp = String(format: "%.0f", maxT - 273.15)
        }
        cell.tempLbl.text = "Min temp:\(minTemp)°C \nMax temp:\(maxTemp)°C"
        
        if let sp = weatherElement.wind.speed {
            winSpeed = String(format: "%.0f", sp)
        }
        cell.windLbl.text = "Wind Speed: \(winSpeed)"
        
        cell.tempDescLbl.text = "Description: \(weatherElement.weather[0].weatherDescription)"
        return cell
    }
    
    //***************************************************************************//
    //
    //***************************************************************************//
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //***************************************************************************//
    //
    //***************************************************************************//
    
    func startFetchTemperatureData(index:Int)
    {
        if index < selectedCitiesList.count
        {
            let city = selectedCitiesList[index]
            requestServerForCityWeather(city: city, index:index)
        }
        else
        {
            UIViewController.removeSpinner()
            DispatchQueue.main.async {
                //Show table view here
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    //***************************************************************************//
    //
    //***************************************************************************//
    
    func requestServerForCityWeather(city:SelectedCityDataModel, index:Int)
    {
        let api = String(format: ApiManager.weatherInfoByCityId, city.cityId)
        ApiManager.requestFromServerFor(callName: api, apiMethod: .GET, parameter: [:]) { (bSuccess, response, error) in
            //Fetch response
            if bSuccess
            {
                
                do {
                    // here "jsonData" is the dictionary encoded in JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let weatherObj = try JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.weatherObject.append(weatherObj)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                self.displayAlertMessageWith(title: "Error", messageToDisplay: error)
            }
            
            self.startFetchTemperatureData(index: (index+1))
        }
    }
}
