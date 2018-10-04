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
    
    // MARK: - Dependencies
    
    fileprivate var viewModel: HomeScreenViewModel = {
        let vm = HomeScreenViewModel()
        return vm
    }()
    
    // MARK: - Private properties
    
    fileprivate var notes = [Note]()
    
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
    
    fileprivate let databaseReference = Database.database().reference(withPath: "notes")
    fileprivate var searchController: UISearchController!
    fileprivate var staticNotes: [Note]!
    fileprivate var isShowingOnlyCurrentUsersNotes = false
    
    // MARK: - Public properties
    
    var user: User?
    
    // MARK: - Dependencies
    
    var locationManager: LocationManagerType!
    var noteService: NoteServiceType!
    
    // MARK: - ViewController
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            showSignInScreen()
        }
        if let selectionIndexPath = notesTableView.indexPathForSelectedRow {
            notesTableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        fetchNotes()
        setupNotifications()
        
        requestLocationAuthorization(with: locationManager.authorizationStatus)
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        view.addSubview(notesTableView)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        notesTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupSearchController() {
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
            navigationItem.titleView?.layoutSubviews()
        }
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
        
        setupSearchController()
    }
    
    fileprivate func showSignInScreen() {
        let signInViewController = SignInViewController()
        let navController = UINavigationController(rootViewController: signInViewController)
        present(navController, animated: false)
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
        }
    }
    
    fileprivate func fetchNotes() {
        Database.fetchNotes { (notes) in
            self.notes = notes
            self.staticNotes = notes
            self.notesTableView.reloadData()
        }
    }
    
    fileprivate func requestLocationAuthorization(with status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            showLocationRequiredAlert()
        default:
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func sortNotes() {
        
    }
    
    fileprivate func switchBetweenShowAllOrOnlyUsersNotes() {
        if isShowingOnlyCurrentUsersNotes == false {
            guard let uid = user?.uid else { return }
            notes = staticNotes.filter { (note) -> Bool in
                return note.uid == uid
            }
            isShowingOnlyCurrentUsersNotes = true
        } else {
            notes = staticNotes
            isShowingOnlyCurrentUsersNotes = false
        }
        notesTableView.reloadData()
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAndShowNoteAddedAlert), name: AddNoteViewController.refreshTableViewNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowSuccessSignInAlert), name: SignInViewController.successAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowSuccessSignUpAlert), name: SignUpViewController.successAlert, object: nil)
    }
    
    fileprivate func showAlert(with message: String, delay: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func showLocationRequiredAlert() {
        let alert = UIAlertController(title: "No location", message: "Please allow the app to use your location", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleAddNote() {
        guard let userName = user?.userName else { return }
        if locationManager.isLocationAuthorized() {
            let addNoteViewController = AddNoteViewController()
            addNoteViewController.userName = userName
            navigationController?.present(addNoteViewController, animated: true, completion: nil)
        } else {
            showLocationRequiredAlert()
        }
    }
    
    @objc fileprivate func handleShowSuccessSignInAlert() {
        self.notes.removeAll()
        self.fetchNotes()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            let signInMessage = user.userName == "" ? "Successfully signed in" : "Successfully signed in as \(user.userName)"
            self.showAlert(with: signInMessage, delay: 1.5)
        }
    }
    
    @objc fileprivate func handleShowSuccessSignUpAlert() {
        self.notes.removeAll()
        self.fetchNotes()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            let signInMessage = user.userName == "" ? "Successfully created a new user" : "Successfully created new user \(user.userName)"
            self.showAlert(with: signInMessage, delay: 1.5)
        }
    }
    
    @objc fileprivate func refreshAndShowNoteAddedAlert() {
        notes.removeAll()
        fetchNotes()
        showAlert(with: "Note successfully added!", delay: 1.5)
    }
    
    @objc fileprivate func handleShowMap() {
        let mapViewController = MapScreenViewController()
        mapViewController.viewModel = MapScreenViewModel(locationManager: locationManager, noteService: noteService)
//        mapViewController.notes = notes
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc fileprivate func handleSettings() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sort notes by distance", style: .default, handler: { (_) in
            self.sortNotes()
        }))
        let filterByUserText = isShowingOnlyCurrentUsersNotes == false ? "Show only my notes" : "Show all notes"
        alertController.addAction(UIAlertAction(title: filterByUserText, style: .default, handler: { (_) in
            self.switchBetweenShowAllOrOnlyUsersNotes()
        }))
        alertController.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let navController = UINavigationController(rootViewController: SignInViewController())
                self.navigationController?.present(navController, animated: true, completion: nil)
                self.user = nil 
            } catch let error {
                print("Failed to sign out:", error)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            notes = staticNotes
        } else {
            notes = staticNotes.filter({ (note) -> Bool in
                return note.userName.lowercased().contains(searchText.lowercased()) || note.title.lowercased().contains(searchText.lowercased())
            })
        }
        notesTableView.reloadData()
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navController = navigationController else { return }
        let noteDetailsViewController = NoteDetailsViewController()
        noteDetailsViewController.note = notes[indexPath.row]
        navController.pushViewController(noteDetailsViewController, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        let cell = tableView.cellForRow(at: indexPath) as! NoteTableViewCell
//        if cell.note.uid == user?.uid {
//            return true
//        } else {
//            return true
//        }
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            notes.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
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
























