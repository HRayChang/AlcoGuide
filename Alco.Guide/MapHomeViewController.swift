//
//  ViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import MapKit

class MapHomeViewController: UIViewController {
    
    var mapView = MKMapView()
    let buttonLineView = UIView()
    let assembleButton = UIButton()
    let selectScheduleView = UIView()
    let scheduleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupAssembleButton()
        setupMapView()
        setupButtonLineView()
        setupSelectScheduleView()
        setupScheduleView()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    func setupMapView() {
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    func setupButtonLineView() {
        buttonLineView.backgroundColor = UIColor.steelPink
    }
    
    func setupScheduleView() {
        scheduleView.backgroundColor = UIColor.black
        scheduleView.layer.borderColor = UIColor.steelPink.cgColor
        scheduleView.layer.borderWidth = 5
        scheduleView.layer.cornerRadius = 20
        scheduleView.isHidden = true
    }
    
    func setupSelectScheduleView() {
        selectScheduleView.backgroundColor = UIColor.black
        selectScheduleView.layer.borderColor = UIColor.steelPink.cgColor
        selectScheduleView.layer.borderWidth = 5
        selectScheduleView.layer.cornerRadius = 30
        selectScheduleView.isHidden = true
        
        let newScheduleButton = UIButton()
        let addScheduleButton = UIButton()
        let myScheduleButton = UIButton()
        
        newScheduleButton.backgroundColor = UIColor.black
        newScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        newScheduleButton.layer.borderWidth = 5
        newScheduleButton.layer.cornerRadius = 20
        newScheduleButton.setTitle("新增行程", for: .normal)
        newScheduleButton.setTitleColor(UIColor.white, for: .normal)
        newScheduleButton.addTarget(self, action: #selector(newScheduleButtonTapped), for: .touchUpInside)
        
        addScheduleButton.backgroundColor = UIColor.black
        addScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        addScheduleButton.layer.borderWidth = 5
        addScheduleButton.layer.cornerRadius = 20
        addScheduleButton.setTitle("加入行程", for: .normal)
        addScheduleButton.setTitleColor(UIColor.white, for: .normal)
        addScheduleButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        
        myScheduleButton.backgroundColor = UIColor.black
        myScheduleButton.layer.borderColor = UIColor.steelPink.cgColor
        myScheduleButton.layer.borderWidth = 5
        myScheduleButton.layer.cornerRadius = 20
        myScheduleButton.setTitle("我的行程", for: .normal)
        myScheduleButton.setTitleColor(UIColor.white, for: .normal)
        myScheduleButton.addTarget(self, action: #selector(myScheduleButtonTapped), for: .touchUpInside)
        
        newScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        myScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectScheduleView.addSubview(newScheduleButton)
        selectScheduleView.addSubview(addScheduleButton)
        selectScheduleView.addSubview(myScheduleButton)
        
        NSLayoutConstraint.activate([
            newScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            newScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            newScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor, constant: -70), // 這邊之後修改成可計算的
            newScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7),
            
            addScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            addScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            addScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor),
            addScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7),
            
            myScheduleButton.leadingAnchor.constraint(equalTo: selectScheduleView.leadingAnchor, constant: 50),
            myScheduleButton.trailingAnchor.constraint(equalTo: selectScheduleView.trailingAnchor, constant: -50),
            myScheduleButton.centerYAnchor.constraint(equalTo: selectScheduleView.centerYAnchor, constant: 70), // 這邊之後修改成可計算的
            myScheduleButton.heightAnchor.constraint(equalTo: selectScheduleView.heightAnchor, multiplier: 1/7)
        ])
    }
    
    func setupAssembleButton() {
        
        assembleButton.backgroundColor = UIColor.black
        assembleButton.layer.cornerRadius = 56
        
        let wineglassImageView = UIImageView(image: UIImage(systemName: "wineglass.fill"))
        
        wineglassImageView.tintColor = UIColor.steelPink
        
        wineglassImageView.translatesAutoresizingMaskIntoConstraints = false
        
        assembleButton.addSubview(wineglassImageView)
        
        NSLayoutConstraint.activate([
            wineglassImageView.topAnchor.constraint(equalTo: assembleButton.topAnchor, constant: 10),
            wineglassImageView.widthAnchor.constraint(equalTo: wineglassImageView.heightAnchor),
            wineglassImageView.centerXAnchor.constraint(equalTo: assembleButton.centerXAnchor),
            wineglassImageView.bottomAnchor.constraint(equalTo: assembleButton.centerYAnchor, constant: 5)
        ])
        
        assembleButton.addTarget(self, action: #selector(assembleButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        buttonLineView.translatesAutoresizingMaskIntoConstraints = false
        assembleButton.translatesAutoresizingMaskIntoConstraints = false
        selectScheduleView.translatesAutoresizingMaskIntoConstraints = false
        scheduleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(buttonLineView)
        view.addSubview(assembleButton)
        view.addSubview(selectScheduleView)
        view.addSubview(scheduleView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            
            buttonLineView.heightAnchor.constraint(equalToConstant: 12),
            buttonLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonLineView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            
            assembleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3.5),
            assembleButton.heightAnchor.constraint(equalTo: assembleButton.widthAnchor),
            assembleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            assembleButton.centerYAnchor.constraint(equalTo: buttonLineView.centerYAnchor),
            
            selectScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            selectScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            selectScheduleView.heightAnchor.constraint(equalTo: selectScheduleView.widthAnchor),
            selectScheduleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            
            scheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scheduleView.heightAnchor.constraint(equalToConstant: 40),
            scheduleView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20)
        ])
    }
    // MARK: Setup UI -
    
    @objc func assembleButtonTapped() {
        selectScheduleView.isHidden = false
    }
    
    @objc func newScheduleButtonTapped() {
        print("Button tapped!")
    }
    
    @objc func addScheduleButtonTapped() {
        print("Button tapped!")
    }
    
    @objc func myScheduleButtonTapped() {
        print("Button tapped!")
    }
    
}
