//
//  WeatherViewController.swift
//  TempometrApp
//
//  Created by Артём Дмитриев on 08.04.2022.
//

import UIKit

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
//        button.addTarget(self, action: #didTapSearchButton, for: .touchUpInside)
        
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
    
    // осталось включить сюда основную логику и функции по определению локаций
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
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
