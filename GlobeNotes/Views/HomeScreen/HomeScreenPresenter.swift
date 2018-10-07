//
//  HomeScreenViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol HomeScreenPresenterType {
    func requestLocationAuthorization()
    func isLocationAuthorized() -> Bool
    func currentLocation() -> CLLocation?
    func startUpdatingLocation()
    func fetchNotes(completion: @escaping ([Note]) -> ())
    func fetchUser(completion: @escaping (User) -> ())
    func signUserOut(completion: @escaping () -> ())
    func isUserSignedIn() -> Bool
    func sortNotesByDistance( from location: CLLocation, with notes: [Note]) -> [Note]
    func getDistanceFromCurrentLocation(to note: Note) -> String
    
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note])
    func navigateToSignInScreen(in navigationController: UINavigationController)
    func navigateToAddNoteScreen(in navigationController: UINavigationController, with userName: String)
    func navigateToNoteDetailsScreen(in navigationController: UINavigationController, with note: Note)
    
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
    
    func currentLocation() -> CLLocation? {
        return locationManager.usersCurrentLocation
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
    
    func sortNotesByDistance(from location: CLLocation, with notes: [Note]) -> [Note] {
        var sortedNotes = notes
        sortedNotes.sort(by: { $0.creationDate > $1.creationDate })
        sortedNotes.sort(by: { $0.distance(to: location) < $1.distance(to: location) })
        return sortedNotes
    }
    
    func getDistanceFromCurrentLocation(to note: Note) -> String {
        if let currentLocation = currentLocation() {
            var distance = note.distance(to: currentLocation) * 0.00062137
            if distance > 1 {
                distance = distance.rounded()
            }
            return distance.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", distance) : String(format:"%.1f", distance)
        }
        return ""
    }
}

// Navigation

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
        let navController = UINavigationController(rootViewController: signInViewController)
        navigationController.present(navController, animated: true)
    }
    
    func navigateToAddNoteScreen(in navigationController: UINavigationController, with userName: String) {
        let addNotePresenter = AddNotePresenter(locationManager: locationManager)
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.presenter = addNotePresenter
        addNoteViewController.userName = userName
        navigationController.present(addNoteViewController, animated: true)
    }
    
    func navigateToNoteDetailsScreen(in navigationController: UINavigationController, with note: Note) {
        let noteDetailsPresenter = NoteDetailsPresenter()
        let noteDetailsViewController = NoteDetailsViewController()
        noteDetailsViewController.presenter = noteDetailsPresenter
        noteDetailsViewController.note = note
        navigationController.pushViewController(noteDetailsViewController, animated: true)
    }
}
