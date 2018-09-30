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

final class HomeScreenViewController: UIViewController {
    
    /// Dummy data
    
    let dummyNote: [String : Any] = ["title": "A note",
                                     "text": "bla bla bla blaaa bla bla bla",
                                     "latitude": 51.538543,
                                     "longitude": -0.060457,
                                     "creationDate": Date()]
    
    // MARK: - Private properties
    
    fileprivate var notes: [Note]!
    
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
    
    // MARK: - ViewController
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            showSignInScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        
        notes = [Note]()
        let dummyUser = User(uid: "blabla", dictionary: dummyNote)
        let note = Note(user: dummyUser, dictionary: dummyNote)
        notes.append(note)
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNote))
        mapButton.addTarget(self, action: #selector(handleShowMap), for: .touchUpInside)
        let mapNavBarItem = UIBarButtonItem(customView: mapButton)
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        let settingsNavBarItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItems = [mapNavBarItem, settingsNavBarItem]
        navigationController?.navigationBar.barTintColor = .white
    }
    
    fileprivate func showSignInScreen() {
        let signInViewController = SignInViewController()
        let navController = UINavigationController(rootViewController: signInViewController)
        present(navController, animated: false)
    }
    
    @objc fileprivate func handleAddNote() {
        let addNoteViewController = AddNoteViewController()
        navigationController?.present(addNoteViewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleShowMap() {
        
    }
    
    @objc fileprivate func handleSettings() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
























