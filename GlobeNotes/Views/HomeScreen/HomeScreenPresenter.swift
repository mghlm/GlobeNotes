//
//  HomeScreenViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import UIKit

protocol HomeScreenPresenterType {
    func requestLocationAuthorization()
    func isLocationAuthorized() -> Bool
    func startUpdatingLocation()
    
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note])
}

struct HomeScreenPresenter: HomeScreenPresenterType {
    
    // MARK: - Dependencies
    
    fileprivate var noteService: NoteServiceType!
    fileprivate var locationManager: LocationManagerType!
    
    // MARK: - Init
    
    init(noteService: NoteServiceType, locationManager: LocationManagerType) {
        self.noteService = noteService
        self.locationManager = locationManager
    }
    
    // MARK: - Public funtions
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func isLocationAuthorized() -> Bool {
        return locationManager.isLocationAuthorized()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension HomeScreenPresenter {
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note]) {
        let mapScreenPresenter = MapScreenPresenter(locationManager: locationManager, notes: notes)
        let mapScreenViewController = MapScreenViewController()
        mapScreenViewController.presenter = mapScreenPresenter
        navigationController.pushViewController(mapScreenViewController, animated: true)
    }
}
