//
//  HomeScreenViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift
import CoreLocation

final class HomeScreenViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var notes: [Note]!
    
    fileprivate var addNoteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .solid)
        button.setTitleColor(UIColor.rgb(red: 0, green: 122, blue: 255), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        return button
    }()
    
    fileprivate var mapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(String.fontAwesomeIcon(name: .mapMarkerAlt), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .solid)
        button.setTitleColor(UIColor.rgb(red: 0, green: 122, blue: 255), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        return button
    }()
    
    fileprivate var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .solid)
        button.setTitleColor(UIColor.rgb(red: 0, green: 122, blue: 255), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        return button
    }()
    
    fileprivate var notesTableView: UITableView = {
        let tv = UITableView()
        tv.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.id)
        return tv
    }()
    
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var locationManager: CLLocationManager!
    fileprivate var userLatitude: Double?
    fileprivate var userLongitude: Double?
    
    // MARK: - ViewController
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            showSignInScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: AddNoteViewController.refreshTableViewNotificationName, object: nil)
        getUsersLocation()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupRefreshControl()
        
        fetchNotes()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        view.addSubview(notesTableView)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        notesTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Nearby notes"
        addNoteButton.addTarget(self, action: #selector(handleAddNote), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNoteButton)
        mapButton.addTarget(self, action: #selector(handleShowMap), for: .touchUpInside)
        let mapNavBarItem = UIBarButtonItem(customView: mapButton)
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        let settingsNavBarItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItems = [mapNavBarItem, settingsNavBarItem]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        notesTableView.refreshControl = refreshControl
    }
    
    fileprivate func showSignInScreen() {
        let signInViewController = SignInViewController()
        let navController = UINavigationController(rootViewController: signInViewController)
        present(navController, animated: false)
    }
    
    fileprivate func fetchNotes() {
        notes = [Note]()
        let databaseReference = Database.database().reference(withPath: "notes")
        databaseReference.observeSingleEvent(of: .value) { (snapshot) in
            
            self.refreshControl.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var note = Note(user: nil, dictionary: dictionary)
                note.id = key
                self.notes.append(note)
                self.notesTableView.reloadData()
            })
        }
    }
    
    fileprivate func getUsersLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in settings to see notes near you", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func sortNotes() {
        
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleAddNote() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.latitude = userLatitude
        addNoteViewController.longitude = userLongitude 
        navigationController?.present(addNoteViewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRefresh() {
        notes.removeAll()
        fetchNotes()
    }
    
    @objc fileprivate func handleShowMap() {
        
    }
    
    @objc fileprivate func handleSettings() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sort notes by distance", style: .default, handler: { (_) in
            self.sortNotes()
        }))
        alertController.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let navController = UINavigationController(rootViewController: SignInViewController())
                self.navigationController?.present(navController, animated: true, completion: nil)
            } catch let error {
                print("Failed to sign out:", error)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.id) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.note = note
        
        return cell
    }
}

extension HomeScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            print("user's current location:", currentLocation.coordinate)
            userLatitude = currentLocation.coordinate.latitude
            userLongitude = currentLocation.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's current location:", error)
    }
}
























