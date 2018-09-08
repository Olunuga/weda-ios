//
//  WeatherDetailViewController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 22/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var lableTempHigh: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTempLow: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    
    var selectedWeather : Weather? {
        didSet{
           
        }
    }
    
    lazy var viewModel: WeatherDetailViewModel = {
        return WeatherDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initVM()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initVM(){
        let presenterHelper = PresentationHelper()
        if let weatherModel = selectedWeather{
            labelDate.text =  DateHelper().getFriendlyDate(date: weatherModel.date!)
            labelDescription.text = weatherModel.weatherDescription
            labelHumidity.text = presenterHelper.formatHumidity(humidity: weatherModel.humidity)
            labelWindSpeed.text = presenterHelper.formatWindSpeed(windSpeed: weatherModel.windSpeed)
            imageViewIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherModel.iconDesc ?? "cloud").png"), placeholderImage: UIImage(named: "cloud"))
            lableTempHigh.text = presenterHelper.formatTemperature(temperature: weatherModel.tempLow, true)
            labelTempLow.text = presenterHelper.formatTemperature(temperature: weatherModel.tempHigh, true)
        }
        

    }
    
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
