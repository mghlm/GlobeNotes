//
//  HomeScreenViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import FontAwesome_swift
import CoreLocation

final class HomeScreenViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: HomeScreenPresenterType!
    
    // MARK: - Private properties
    
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
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(String.fontAwesomeIcon(name: .mapMarkerAlt), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .solid)
        button.setTitleColor(UIColor.rgb(red: 0, green: 122, blue: 255), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.isUserInteractionEnabled = false
        
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
    
    fileprivate var searchController: UISearchController!
    fileprivate var filteredNotes = [Note]()
    private var allNotes: [Note]!
    fileprivate var isShowingOnlyCurrentUsersNotes = false
    
    // MARK: - Public properties
    
    var user: User?
    
    // MARK: - ViewController
    
    override func viewWillAppear(_ animated: Bool) {
        if !presenter.isUserSignedIn() {
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
        
        presenter.requestLocationAuthorization()
        
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
        guard let navController = navigationController else { return }
        presenter.navigateToSignInScreen(in: navController)
    }
    
    fileprivate func fetchUser() {
        presenter.fetchUser { (user) in
            self.user = user 
        }
    }
    
    fileprivate func fetchNotes() {
        presenter.fetchNotes { (notes) in
            self.allNotes = notes
            // First we sort the notes by date added
            self.allNotes = self.presenter.sortNotesByDateAdded(with: self.allNotes)
            if let currentLocation = self.presenter.currentLocation() {
                // If user's location is authorized, we also sort the notes by distance
                self.allNotes = self.presenter.sortNotesByDistance(from: currentLocation, with: self.allNotes)
            }
            self.filteredNotes = self.allNotes
            self.mapButton.isUserInteractionEnabled = true
            self.notesTableView.reloadData()
        }
    }
    
    fileprivate func requestLocationAuthorization(with status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            presenter.requestLocationAuthorization()
            return
        case .denied, .restricted:
            showLocationRequiredAlert()
        default:
            presenter.startUpdatingLocation()
        }
    }
    
    fileprivate func switchBetweenShowAllOrOnlyUsersNotes() {
        if isShowingOnlyCurrentUsersNotes == false {
            guard let uid = user?.uid else { return }
            filteredNotes = allNotes.filter { (note) -> Bool in
                return note.uid == uid
            }
            isShowingOnlyCurrentUsersNotes = true
        } else {
            filteredNotes = allNotes
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
        guard let navController = navigationController else { return }
        if presenter.isLocationAuthorized() {
            presenter.navigateToAddNoteScreen(in: navController, with: userName)
        } else {
            showLocationRequiredAlert()
        }
    }
    
    @objc fileprivate func handleShowSuccessSignInAlert() {
        filteredNotes.removeAll()
        fetchNotes()
        presenter.fetchUser { (user) in
            self.user = user
            let signInMessage = "Successfully signed in as \(user.userName)"
            self.showAlert(with: signInMessage, delay: 1.5)
        }
    }
    
    @objc fileprivate func handleShowSuccessSignUpAlert() {
        self.filteredNotes.removeAll()
        self.fetchNotes()
        presenter.fetchUser { (user) in
            self.user = user
            let signInMessage = "Successfully created new user \(user.userName)"
            self.showAlert(with: signInMessage, delay: 1.5)
        }
    }
    
    @objc fileprivate func refreshAndShowNoteAddedAlert() {
        filteredNotes.removeAll()
        fetchNotes()
        showAlert(with: "Note successfully added!", delay: 1.5)
    }
    
    @objc fileprivate func handleShowMap() {
        guard let navController = navigationController else { return }
        presenter.navigateToMapScreen(in: navController, with: allNotes)
    }
    
    @objc fileprivate func handleSettings() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let filterByUserText = isShowingOnlyCurrentUsersNotes == false ? "Show only my notes" : "Show all notes"
        alertController.addAction(UIAlertAction(title: filterByUserText, style: .default, handler: { (_) in
            self.switchBetweenShowAllOrOnlyUsersNotes()
        }))
        alertController.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { (_) in
            
            self.presenter.signUserOut {
                guard let navController = self.navigationController else { return }
                self.presenter.navigateToSignInScreen(in: navController)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredNotes = allNotes
        } else {
            filteredNotes = allNotes.filter({ (note) -> Bool in
                return note.userName.lowercased().contains(searchText.lowercased()) || note.title.lowercased().contains(searchText.lowercased())
            })
        }
        notesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchNotes()
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navController = navigationController else { return }
        presenter.navigateToNoteDetailsScreen(in: navController, with: filteredNotes[indexPath.row], uid: user?.uid)
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.id) as! NoteTableViewCell
        let note = filteredNotes[indexPath.row]
        cell.delegate = self
        cell.note = note
        
        return cell
    }
}

extension HomeScreenViewController: NoteTableViewCellDelegate {
    func getDistanceFromCurrenLocation(to note: Note) -> String {
        return presenter.getDistanceFromCurrentLocation(to: note)
    }
}
























