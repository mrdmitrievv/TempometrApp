//
//  WeatherViewController.swift
//  TempometrApp
//
//  Created by Артём Дмитриев on 08.04.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let mainView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "main")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let weatherIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark.icloud.fill")
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont(name: "Copperplate", size: 30)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "0°C"
        label.font = UIFont(name: "Copperplate", size: 60)
        label.textAlignment = .center
        label.tintColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    let feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Feels Like: 0°C"
        label.font = UIFont(name: "Copperplate", size: 20)
        label.backgroundColor = .clear
        label.tintColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var networkManager = NetworkManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(weather: currentWeather)            
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.feelsLikeTemperatureLabel.text = "Feels like: \(weather.feelsLikeTemperatureString)°C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
            self.mainView.image = UIImage(named: weather.mainViewString)
        }
    }
    
    @objc func didTapSearchButton() {
        self.presentSearchAlertController(withTitle: "Enter the city", message: nil, style: .alert) { [unowned self] city in
            self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    private func setupConstraints() {
        view.addSubview(mainView)
        mainView.addSubview(weatherIconImageView)
        mainView.addSubview(temperatureLabel)
        mainView.addSubview(feelsLikeTemperatureLabel)
        mainView.addSubview(cityLabel)
        mainView.addSubview(searchButton)
        
        [mainView, weatherIconImageView, temperatureLabel, feelsLikeTemperatureLabel, cityLabel, searchButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 200),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 30),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            feelsLikeTemperatureLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor)
        ])
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping(String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Moscow", "London", "Saint-Peterburg", "Berlin", "Paris"]
            tf.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
