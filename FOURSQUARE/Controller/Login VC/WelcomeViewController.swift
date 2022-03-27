//
//  WelcomeViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 24/03/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpWithEmailBtn: UIButton!
    @IBOutlet weak var signUpWithFbBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }

    func configure() {
        signUpWithEmailBtn.layer.cornerRadius = 15
        signUpWithEmailBtn.layer.borderWidth = 1
        signUpWithEmailBtn.layer.borderColor = UIColor(red: 249/255, green: 72/255, blue: 120/255, alpha: 1).cgColor

        signUpWithFbBtn.layer.cornerRadius = 15
    }

    @IBAction func loginDidTap(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
        navigationItem.backButtonTitle = ""
    }

    @IBAction func signUpWithEmailDidTap(_ sender: Any) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    @IBAction func signUpWithFbDidTap(_ sender: Any) {
    }

}
