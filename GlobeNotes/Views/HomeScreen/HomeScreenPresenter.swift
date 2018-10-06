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
    func fetchNotes(completion: @escaping ([Note]) -> ())
    func fetchUser(completion: @escaping (User) -> ())
    func signUserOut(completion: @escaping () -> ())
    func isUserSignedIn() -> Bool
    
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note])
    func navigateToSignInScreen(in navigationController: UINavigationController)
}

struct HomeScreenPresenter: HomeScreenPresenterType {
    
    // MARK: - Dependencies
    
    fileprivate var noteService: NoteServiceType!
    fileprivate var authService: AuthServiceType!
    fileprivate var locationManager: LocationManagerType!
    
    // MARK: - Init
    
    init(noteService: NoteServiceType, authService: AuthServiceType, locationManager: LocationManagerType) {
        self.noteService = noteService
        self.authService = authService
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
    
    func fetchNotes(completion: @escaping ([Note]) -> ()) {
        noteService.fetchNotes { (notes) in
            completion(notes)
        }
    }
    
    func fetchUser(completion: @escaping (User) -> ()) {
        authService.fetchUser { (user) in
            completion(user)
        }
    }
    
    func signUserOut(completion: @escaping () -> ()) {
        authService.signUserOut {
            completion()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return authService.isUserSignedIn()
    }
}

extension HomeScreenPresenter {
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note]) {
        let mapScreenPresenter = MapScreenPresenter(locationManager: locationManager, notes: notes)
        let mapScreenViewController = MapScreenViewController()
        mapScreenViewController.presenter = mapScreenPresenter
        navigationController.pushViewController(mapScreenViewController, animated: true)
    }
    
    func navigateToSignInScreen(in navigationController: UINavigationController) {
        let signInPresenter = SignInPresenter(authService: authService)
        let signInViewController = SignInViewController()
        signInViewController.presenter = signInPresenter
        navigationController.present(signInViewController, animated: true)
    }
}
