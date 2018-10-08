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
    
    /// Requests to use the location when the app is in use
    func requestLocationAuthorization()
    
    /// Checks if the user has given permission for the app to use location
    ///
    /// - Returns: True or false
    func isLocationAuthorized() -> Bool
    
    /// Checks the last known location of the user
    ///
    /// - Returns: Optional CLLocation of last known location if any
    func currentLocation() -> CLLocation?
    
    /// Starts updating the current location
    func startUpdatingLocation()
    
    /// Fetches all notes from firebase server
    ///
    /// - Parameter completion: To be called after all notes are fetched
    /// - Returns: Completion with array of all notes
    func fetchNotes(completion: @escaping ([Note]) -> ())
    
    /// Fetches the user object of currently signed in user
    ///
    /// - Parameter completion: To be called when user is fetched
    /// - Returns: Completion with User object
    func fetchUser(completion: @escaping (User) -> ())
    
    /// Signs out the currently signed in user
    ///
    /// - Parameter completion: To be called when user is successfully signed out
    /// - Returns: Completion
    func signUserOut(completion: @escaping () -> ())
    
    /// Checks if a user is currently signed in
    ///
    /// - Returns: True or false
    func isUserSignedIn() -> Bool
    
    /// Sorts an array of notes by the time they were added to the database
    ///
    /// - Parameter notes: The collection of notes to sort
    /// - Returns: A new collection of sortet notes
    func sortNotesByDateAdded(with notes: [Note]) -> [Note]
    
    /// Sorts an array of notes by distance to a given location
    ///
    /// - Parameters:
    ///   - location: The location to measure distance to
    ///   - notes: The collection of notes to sort
    /// - Returns: A new collection of sorted notes
    func sortNotesByDistance( from location: CLLocation, with notes: [Note]) -> [Note]
    
    /// Gets the distance from the current location to where a given note was added
    ///
    /// - Parameter note: The note to measure distance to
    /// - Returns: Distance in miles as a String. If distance < 1, distance is rounded to .1, otherwise rounded to 1
    func getDistanceFromCurrentLocation(to note: Note) -> String
    
    
    /// Pushes the map screen VC
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to push the new VC in
    ///   - notes: The notes to show in the map
    func navigateToMapScreen(in navigationController: UINavigationController, with notes: [Note])
    
    /// Presents the modal sign in screen
    ///
    /// - Parameter navigationController: The navigation controller to present the new VC in
    func navigateToSignInScreen(in navigationController: UINavigationController)
    
    /// Presents the add notes modal VC
    ///
    /// - Parameters:
    ///   - navigationController: navigationController: The navigation controller to present the new VC in
    ///   - userName: The user name of the currently signed in user, to use if user submits a new note
    func navigateToAddNoteScreen(in navigationController: UINavigationController, with userName: String)
    
    /// Pushes the note details screen
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to push the new VC in
    ///   - note: The note to show details about
    ///   - uid: The uid of the currently signed in user to use to compare with that of the note
    func navigateToNoteDetailsScreen(in navigationController: UINavigationController, with note: Note, uid: String?)
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
    
    func sortNotesByDateAdded(with notes: [Note]) -> [Note] {
        var sortedNotes = notes
        sortedNotes.sort(by: { $0.creationDate > $1.creationDate })
        return sortedNotes
    }
    
    func sortNotesByDistance(from location: CLLocation, with notes: [Note]) -> [Note] {
        var sortedNotes = notes
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
        mapScreenViewController.arrivedFromDetails = false 
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
        let addNotePresenter = AddNotePresenter(locationManager: locationManager, noteService: noteService)
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.presenter = addNotePresenter
        addNoteViewController.userName = userName
        navigationController.present(addNoteViewController, animated: true)
    }
    
    func navigateToNoteDetailsScreen(in navigationController: UINavigationController, with note: Note, uid: String?) {
        let noteDetailsPresenter = NoteDetailsPresenter(locationManager: locationManager, authService: authService)
        let noteDetailsViewController = NoteDetailsViewController()
        noteDetailsViewController.presenter = noteDetailsPresenter
        noteDetailsViewController.uid = uid
        noteDetailsViewController.note = note
        navigationController.pushViewController(noteDetailsViewController, animated: true)
    }
}
