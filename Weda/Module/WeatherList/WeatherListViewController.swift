//
//  ViewController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit

class WeatherListViewController: UITableViewController {

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
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 0.0
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })
            }
            }}
        
        viewModel.reloadDataClosure = {[weak self]() in DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
    
    func confifgureTableView() {
        tableView.register(UINib(nibName: "TodayViewCell", bundle: nil), forCellReuseIdentifier: "TodayViewCell")
        tableView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 241.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = (viewModel.getWeatherModelForCellAt(row: indexPath.row)).temperature
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
        return viewModel.dataCount
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}


