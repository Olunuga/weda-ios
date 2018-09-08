//
//  ViewController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class WeatherListViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var viewNoLabel: UIView!
    @IBOutlet weak var UITbaleView: UITableView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var lableNoData: UILabel!
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var selectedRow : Int?
    var fromView = false;
    
    //TODO: allow user input location them selves |show full weather data for other days when selected | Make status bar opaque | Refactoe code | MVP done :-)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManger()
        confifgureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isLocationAVailableToUse() {
            viewNoLabel.isHidden = true
            if(CheckInternet.Connection()){
                
                if !fromView{
                    self.progressBar.startAnimating()
                    fromView = false
                }
            
                locationManager.startUpdatingLocation()
            }else{
                showNoNetworkAlert()
                initVM(with: "") //get current user saved location here.
            }
            
        }
        
    }
    
    
    func isLocationAVailableToUse() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status != CLAuthorizationStatus.denied {
                return true
            }else{
                let action = UIAlertAction(title: "Allow Location", style: .default) { (action) in
                    self.openSettings(for: URL(string:UIApplicationOpenSettingsURLString))
                    self.viewNoLabel.isHidden = false
                    self.lableNoData.text = "Location acess not granted, Allow 'WEDA' to access your location data"
                }
                showAlert(title: "Allow Location", message: "Weda needs your location to show you the weather details", action: action)
                return false
            }
            
        }else{
            let action = UIAlertAction(title: "Turn on", style: .default) { (action) in
                self.openSettings(for: URL(string: "App-Prefs:root=Privacy&path=LOCATION"))
                self.viewNoLabel.isHidden = false
                self.lableNoData.text = "Location data not available,\nTurn on your location service"
            }
            showAlert(title: "Turn location on", message: "Weda needs your location to show you the weather details", action: action)
            return false
        }
        
    }
    
    func openSettings(for urlToOpen: URL?){
        self.progressBar.isHidden = true
        if let url = urlToOpen {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func initLocationManger(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard let currentLocPlacemark = placemarks?.first else { return }
                if let locality = currentLocPlacemark.administrativeArea {
                    self.initVM(with: locality)
                    print(locality)
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func showAlert(title: String,message: String, action : UIAlertAction){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true,completion: nil)
    }
    
    
    func initVM(with location: String){
        self.progressBar.hidesWhenStopped = true
        self.progressBar.startAnimating()
        viewNoLabel.isHidden = true
        
        viewModel.updateLoadingStatusClosure = {[weak self] () in DispatchQueue.main.async {
            let isLoading = self?.viewModel.isDataLoading ?? false
            if isLoading {
                self?.viewNoLabel.isHidden = true
                UIView.animate(withDuration: 0.2, animations: {
                    self?.UITbaleView.alpha = 0.0
                })
            }else{
                self?.progressBar.stopAnimating()
                self?.handleEmptyData()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.UITbaleView.alpha = 1.0
                })
            }
            }}
        
        viewModel.reloadDataClosure = {[weak self]() in DispatchQueue.main.async {
            self?.UITbaleView.reloadData()
            }
        }
        
        viewModel.showAlert = {[weak self]() in DispatchQueue.main.async {
            self?.showNoNetworkAlert()
            }}
        
        viewModel.initFetch(location:location)
    }
    
    
    func showNoNetworkAlert(){
        progressBar.isHidden = true
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
        }
        showAlert(title: "No Connectivity", message: "Showing saved data, Turn on your internet connectivity to get updated weather details", action: action)
    }
    
    func handleEmptyData(){
        if  viewModel.dataCount == 0 {
            viewNoLabel.isHidden = false
            //Show the location for which weather data is not available for
            UITbaleView.separatorStyle = .none
        }else{
            viewNoLabel.isHidden = true
            UITbaleView.separatorStyle = .singleLine
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetail" {
            let destinationVc = segue.destination as! WeatherDetailViewController
            destinationVc.selectedWeather = viewModel.getWeatherModelForCellAt(row: selectedRow!)
        }
    }
    
    //MARK: Table logics
    
    func confifgureTableView() {
        UITbaleView.register(UINib(nibName: "TodayViewCell", bundle: nil), forCellReuseIdentifier: "TodayViewCell")
        UITbaleView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalViewCell")
        UITbaleView.delegate = self
        UITbaleView.dataSource = self
        UITbaleView.rowHeight = UITableViewAutomaticDimension
        UITbaleView.estimatedRowHeight = 241.0
    }
    
}


extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.dataCount == 0 {
            tableView.separatorStyle = .none
        }else{
            tableView.separatorStyle = .singleLine
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        fromView = true;
        performSegue(withIdentifier: "openDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherModel = viewModel.getWeatherModelForCellAt(row: indexPath.row)
        let presentationHelper = PresentationHelper()
       
        //TODO: refactoor this code here
        if indexPath.row == 0{
            let todayViewell = tableView.dequeueReusableCell(withIdentifier: "TodayViewCell", for: indexPath) as! TodayViewCell
            todayViewell.labelRegion.text = viewModel.location!
            todayViewell.lableTemperature.text = presentationHelper.formatTemperature(temperature: weatherModel.tempHigh,true)
            todayViewell.labelHumidity.text = presentationHelper.formatHumidity(humidity: weatherModel.humidity)
            todayViewell.labelWindSpeed.text = presentationHelper.formatWindSpeed(windSpeed: weatherModel.windSpeed)
            todayViewell.labelDescription.text = weatherModel.weatherDescription
            todayViewell.isUserInteractionEnabled = false
            todayViewell.labelTemperatureLow.text = presentationHelper.formatTemperature(temperature: weatherModel.tempLow, true)
            todayViewell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc ?? "cloud").png"), placeholderImage: UIImage(named: "cloud"))
            
            return todayViewell
        }else {
            let normalViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalViewCell") as! NormalViewCell
            normalViewCell.labelTemperature.text = presentationHelper.formatTemperature(temperature: weatherModel.tempHigh, false)
            normalViewCell.labelDay.text = viewModel.getFriendlyDate(date: weatherModel.date!)
            normalViewCell.labelDescription.text = weatherModel.weatherDescription
            normalViewCell.labelTempLow.text = presentationHelper.formatTemperature(temperature: weatherModel.tempLow, false)
            normalViewCell.selectionStyle = .default
            normalViewCell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc ?? "cloud").png"), placeholderImage: UIImage(named: "cloud"))
            return normalViewCell
        }
    }
}


