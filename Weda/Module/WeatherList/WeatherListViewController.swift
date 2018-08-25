//
//  ViewController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherListViewController: UIViewController{

    @IBOutlet weak var UITbaleView: UITableView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    lazy var viewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confifgureTableView()
        initVM()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initVM(){
        viewModel.updateLoadingStatusClosure = {[weak self] () in DispatchQueue.main.async {
            let isLoading = self?.viewModel.isDataLoading ?? false
            if isLoading {
                self?.progressBar.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.UITbaleView.alpha = 0.0
                })
            }else{
                self?.progressBar.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.UITbaleView.alpha = 1.0
                })
            }
            }}

        viewModel.reloadDataClosure = {[weak self]() in DispatchQueue.main.async {
                self?.UITbaleView.reloadData()
            }
        }

        viewModel.initFetch()
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

        if indexPath.row == 0{
            let todayViewell = tableView.dequeueReusableCell(withIdentifier: "TodayViewCell", for: indexPath) as! TodayViewCell
            todayViewell.lableTemperature.text = tempFormat
            todayViewell.labelHumidity.text = "\(weatherModel.humidity!)"
            todayViewell.labelWindSpeed.text = "\(weatherModel.windSpeed!) Km/hr"
            todayViewell.labelDescription.text = weatherModel.description!
            todayViewell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc!).png"), placeholderImage: UIImage(named: "cloud"))

            return todayViewell
        }else {
            let normalViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalViewCell") as! NormalViewCell
            normalViewCell.labelTemperature.text = tempFormat
            //normalViewCell.imageIcon.image = UIImage(named: "cloud")
            normalViewCell.imageIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc!).png"), placeholderImage: UIImage(named: "cloud"))
            return normalViewCell
        }
    }
}

