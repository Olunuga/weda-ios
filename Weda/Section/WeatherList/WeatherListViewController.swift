//
//  ViewController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit

class WeatherListViewController: UITableViewController {
    var weatherArray : [Weather]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        confifgureTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func confifgureTableView() {
        tableView.register(UINib(nibName: "TodayViewCell", bundle: nil), forCellReuseIdentifier: "TodayViewCell")
        tableView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 241.0
    }
    
    func getData(){
        let weatherController : WeatherController = WeatherController(total: 10)
        weatherArray = weatherController.getWeather()
    }
    
    
    //MARK: TableView setups
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = (weatherArray![indexPath.row] as Weather).temperature
        let tempFormat = "\(temp) ℃"
        
        if indexPath.row == 0{
            let todayViewell = tableView.dequeueReusableCell(withIdentifier: "TodayViewCell", for: indexPath) as! TodayViewCell
                todayViewell.lableTemperature.text = tempFormat
            return todayViewell
        }else {
            let normalViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalViewCell") as! NormalViewCell
            normalViewCell.labelTemperature.text = tempFormat
            normalViewCell.imageIcon.image = UIImage(named: "cloud")
            return normalViewCell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (weatherArray?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

