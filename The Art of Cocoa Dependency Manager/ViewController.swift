//
//  ViewController.swift
//  The Art of Cocoa Dependency Manager
//
//  Created by Looping on 4/10/16.
//  Copyright © 2016 RidgeCorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var latestUpdatingLabel: UILabel!
    @IBOutlet weak var refreshIndicatorView: UIActivityIndicatorView!
    
    var weather = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.hidden = true
        temperatureLabel.hidden = true
        
        loadWeatherInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWeatherInfo() {
        refreshIndicatorView.startAnimating()
        
        latestUpdatingLabel.hidden = true
        
        Manager.sharedInstance.request(.GET, "http://www.weather.com.cn/data/sk/101210101.html").responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let weatherInfo = (JSON as! NSDictionary).objectForKey("weatherinfo") as! NSDictionary
                
                self.weather.city = weatherInfo.objectForKey("city") as! String
                self.weather.temperature = weatherInfo.objectForKey("temp") as! String
                self.weather.updatingTime = weatherInfo.objectForKey("time") as! String
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
            
            self.displayWeather();
        }
    }
    
    func displayWeather() {
        refreshIndicatorView.stopAnimating()
        
        cityLabel.hidden = false
        temperatureLabel.hidden = false
        latestUpdatingLabel.hidden = false
        
        cityLabel.text = weather.city
        temperatureLabel.text = weather.temperature
        latestUpdatingLabel.text = weather.updatingTime
    }
    
    @IBAction func refreshAction(sender: UIButton) {
        refreshIndicatorView.startAnimating()
        latestUpdatingLabel.hidden = true
        
        loadWeatherInfo()
    }

}

