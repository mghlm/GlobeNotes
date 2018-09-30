//
//  AddNoteViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 30/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add a note!"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "✏️"
        lbl.font = UIFont.systemFont(ofSize: 80)
        
        return lbl
    }()
    
    fileprivate var titleTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 0.4
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 6
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    fileprivate var textTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 0.4
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 6
        tv.clipsToBounds = true
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = UIColor.lightGray
        tv.text = "Write your note here"
        
        return tv
    }()
    
    fileprivate var submitUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        view.addSubview(emojiLabel)
        view.addSubview(mainTitleLabel)
        view.addSubview(titleTextField)
        textTextView.delegate = self
        view.addSubview(textTextView)
        view.addSubview(submitUpButton)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        emojiLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emojiLabel.anchor(centerX: view.centerXAnchor, centerY: nil)
        titleTextField.anchor(top: emojiLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        textTextView.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 200)
        submitUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 24, width: 0, height: 50)
    }
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleTextInputChange() {
        let isFormValid = titleTextField.text?.isEmpty == false
        
        if isFormValid {
            submitUpButton.isEnabled = true
            submitUpButton.backgroundColor = UIColor.blue
        } else {
            submitUpButton.isEnabled = false
            submitUpButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc fileprivate func handleSubmit() {
        
    }
    
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textTextView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textTextView.text.isEmpty {
            textView.text = "Write your note here"
            textView.textColor = UIColor.lightGray
        }
    }
}



















