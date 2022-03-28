//
//  MeViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import FBSDKLoginKit

class MeViewController: UIViewController {


    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var logOutBtn: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateMessage(with: Profile.current?.name)
        
    }

    @IBAction func logOutBtnDidTap(_ sender: Any) {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
            UserDefaults.standard.set(false, forKey: "isLogin")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(WelcomeViewController(), loginVC: true)
        }
    }
}

extension MeViewController {
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
