//
//  Coordinator.swift
//  GlobeNotes
//
//  Created by magnus holm on 05/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

struct AppCoordinator: Coordinator {
    
    // MARK: - Dependencies
    
    fileprivate var window: UIWindow!
    fileprivate var authService: AuthServiceType!
    fileprivate var noteService: NoteServiceType!
    fileprivate var locationManager: LocationManagerType!
    
    // MARK: - Init
    
    init(window: UIWindow, authService: AuthServiceType, noteService: NoteServiceType, locationManager: LocationManagerType) {
        self.window = window
        self.authService = authService
        self.noteService = noteService
        self.locationManager = locationManager
    }
    
    // MARK: - Public methods
    
    func start() {
        let rootViewController = HomeScreenViewController()
        let navController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
