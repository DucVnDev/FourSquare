//
//  LoginViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 24/03/2022.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signInFbBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var fogotBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        //1
        updateButton(isLoggedIn: (AccessToken.current != nil))
        updateMessage(with: Profile.current?.name)

        // Observe access token changes
        // This will trigger after successfully login / logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in

            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }

    func configure() {
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.masksToBounds = true

        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(systemName: "envelope"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)

        emailTextField.leftView = button
        emailTextField.leftViewMode = .always

        passTextField.layer.cornerRadius = 10.0
        passTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passTextField.layer.borderWidth = 1.0
        passTextField.layer.borderColor = UIColor.darkGray.cgColor
        passTextField.layer.masksToBounds = true

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage.init(systemName: "bag"), for: .normal)
        button1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button1.addTarget(self, action: #selector(refresh), for: .touchUpInside)

        passTextField.leftView = button1
        passTextField.leftViewMode = .always

        loginBtn.layer.cornerRadius = 15

        signInFbBtn.layer.cornerRadius = 15

    }

    @objc func refresh() {
    }

    @IBAction func loginBtnDidTap(_ sender: Any) {
    }

    @IBAction func forgotBtnDidTap(_ sender: Any) {
    }

    @IBAction func signInFbBtnDidTap(_ sender: Any) {
        //1
        let loginManager = LoginManager()

        if let _ = AccessToken.current {
            loginManager.logOut()
            updateButton(isLoggedIn: false)
            updateMessage(with: nil)
        } else {

            loginManager.logIn(permissions: [], from: self) { [weak self] result, error in
                //Check  for error
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                //Check for cancel
                guard let result = result, !result.isCancelled  else {
                    print("User cancelled login")
                    return
                }

                //Successfully logged in
                self?.updateButton(isLoggedIn: true)
                Profile.loadCurrentProfile { (profile, error) in
                    self?.updateMessage(with: Profile.current?.name)
                }
            }
        }
    }
}



extension LoginViewController {

    private func updateButton(isLoggedIn: Bool) {
        // 1
        let title = isLoggedIn ? "Log out" : "Sign in with Facebook"
        signInFbBtn.setTitle(title, for: .normal)
    }

    private func updateMessage(with name: String?) {
        // 2
        guard let name = name else {
            // User already logged out
            messageLabel.text = "Please log in with Facebook."
            return
        }

        // User already logged in
        messageLabel.text = "Hello, \(name)!"
    }
}
