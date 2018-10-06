//
//  HomeScreenViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

protocol HomeScreenPresenterType {
    
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
    
}
