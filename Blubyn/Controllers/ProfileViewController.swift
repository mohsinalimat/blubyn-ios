//
//  ProfileViewController.swift
//  Blubyn
//
//  Created by JOGENDRA on 03/02/18.
//  Copyright © 2018 Jogendra Singh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: JSTextField! {
        didSet {
            firstNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var lastNameTextField: JSTextField! {
        didSet {
            lastNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var phoneNumberTextField: JSTextField! {
        didSet {
            phoneNumberTextField.delegate = self
        }
    }
    
    @IBOutlet weak var emailTextField: JSTextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    fileprivate var isEditingMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetups()
        textFieldsEditingMode(isEditable: false)
        editButtonInitialUISetup()
        fetchUserFacebookProfileData()
        self.navigationItem.title  = "Edit Profile"
    }
    
    fileprivate func initialUISetups() {
        
        editProfileButton.layer.borderWidth = 0.5
        editProfileButton.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        editProfileButton.layer.cornerRadius = 0.5 * editProfileButton.frame.width
    }
    
    // MARK: - Fetch Facebook Profile Data
    
    fileprivate func fetchUserFacebookProfileData() {
        
        BlubynCommons.fetchUserProfileData(completion: { (connection, result, error) in
            print(result)
            let parsedJSON = JSON(result)
            
            let firstName = parsedJSON["first_name"].string
            let lastName = parsedJSON["last_name"].string
            let userEmail = parsedJSON["email"].string
            
            self.firstNameTextField.text = firstName ?? ""
            self.lastNameTextField.text = lastName ?? ""
            self.emailTextField.text = userEmail ?? ""
            
            guard let userFirstName = firstName else {
                return
            }
            self.userNameLabel.text = userFirstName
            if let userLastName = lastName {
                self.userNameLabel.text = userFirstName + " " + userLastName
            }
        })
    }
    
    fileprivate func textFieldsEditingMode(isEditable: Bool) {
        
        firstNameTextField.isEnabled = isEditable
        lastNameTextField.isEnabled = isEditable
        phoneNumberTextField.isEnabled = isEditable
        emailTextField.isEnabled = isEditable
        
    }
    
    fileprivate func editButtonInitialUISetup() {
        
        let editButtonImage = UIImage(named: "edit-profile")
        editProfileButton.setImage(editButtonImage, for: .normal)
        editProfileButton.backgroundColor = UIColor(named: "appThemeColor")
    }

    @IBAction func didTapEditProfile(_ sender: Any) {
        
        if isEditingMode {
            editButtonInitialUISetup()
            textFieldsEditingMode(isEditable: false)
            isEditingMode = false
        } else {
            textFieldsEditingMode(isEditable: true)
            let saveButtonImage = UIImage(named: "save-profile")
            editProfileButton.setImage(saveButtonImage, for: .normal)
            editProfileButton.backgroundColor = UIColor(named: "appGreen")
            isEditingMode = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.endEditing(true)
        lastNameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
        emailTextField.endEditing(true)
        return true
    }
}
