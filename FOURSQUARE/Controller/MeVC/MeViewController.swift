//
//  MeViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import FBSDKLoginKit

class MeViewController: UIViewController {


    @IBOutlet weak var imageUserImageView: UIImageView!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!


    @IBOutlet weak var logOutBtn: UIButton!
    //@IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        updateMessage(with: Profile.current?.name)
        updateButton(isLoggedIn: (AccessToken.current != nil))
    }

    @IBAction func logOutBtnDidTap(_ sender: Any) {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
            UserDefaults.standard.set(false, forKey: "isLogin")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MeLoginViewController(), loginVC: true)
        } else {
            //TODO
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MeLoginViewController(), loginVC: true)
        }
    }

}

extension MeViewController {
    private func updateMessage(with name: String?) {
        // 2
        guard let name = name else {
            // User already logged out
            userName.text = "User name"
            return
        }
        // User already logged in
        userName.text = "Hello, \(name)!"
    }

    private func updateButton(isLoggedIn: Bool) {
        // 1
        let title = isLoggedIn ? "Log out" : "Sign in with Facebook"
        logOutBtn.setTitle(title, for: .normal)
    }
}
