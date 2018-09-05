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
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    //TODO: allow user input location them selves | handle location failed | Handle when there is no network | Handle when data is empty show full weather data for other days when selected | Make status bar opaque | Refactoe code | MVP done :-)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManger()
        confifgureTableView()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !CLLocationManager.locationServicesEnabled() {
            showAlert()
            print("location service not enabled")
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status != CLAuthorizationStatus.authorizedWhenInUse {
            showAlert()
            print("location service not authorized")
        }else{
            self.progressBar.startAnimating()
            locationManager.startUpdatingLocation()
            print("location service updating")
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
    
    func showAlert(){
        let alert = UIAlertController(title: "Please turn on Location", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel) { (acton) in
         
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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

        viewModel.initFetch(location:location)
    }
    
    func handleEmptyData(){
        if  viewModel.dataCount == 0 {
            viewNoLabel.isHidden = false
            UITbaleView.separatorStyle = .none
        }else{
            viewNoLabel.isHidden = true
            UITbaleView.separatorStyle = .singleLine
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetail" {
            
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
        
        performSegue(withIdentifier: "openDetail", sender: self)
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherModel = viewModel.getWeatherModelForCellAt(row: indexPath.row)
        let temp = weatherModel.temperature
        let tempFormat = "\(temp!) ℃"

        
        //TODO: refactoor this code here
        if indexPath.row == 0{
            let todayViewell = tableView.dequeueReusableCell(withIdentifier: "TodayViewCell", for: indexPath) as! TodayViewCell
            todayViewell.labelRegion.text = viewModel.location!
            todayViewell.lableTemperature.text = tempFormat
            todayViewell.labelHumidity.text = "\(Int(weatherModel.humidity))%"
            todayViewell.labelWindSpeed.text = "\(weatherModel.windSpeed) Km/hr"
            todayViewell.labelDescription.text = weatherModel.weatherDescription
            todayViewell.isUserInteractionEnabled = false
            todayViewell.labelTemperatureLow.text = "\(Int(weatherModel.tempLow))℃"
            todayViewell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc ?? "cloud").png"), placeholderImage: UIImage(named: "cloud"))

            return todayViewell
        }else {
            let normalViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalViewCell") as! NormalViewCell
            normalViewCell.labelTemperature.text = "\(temp ?? "N/A")°"
            normalViewCell.labelDay.text = viewModel.getFriendlyDate(date: weatherModel.date!)
            normalViewCell.labelDescription.text = weatherModel.weatherDescription
            normalViewCell.labelTempLow.text = "\(Int(weatherModel.tempLow))°"
            normalViewCell.selectionStyle = .default
            normalViewCell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc ?? "cloud").png"), placeholderImage: UIImage(named: "cloud"))
            return normalViewCell
        }
    }
}


