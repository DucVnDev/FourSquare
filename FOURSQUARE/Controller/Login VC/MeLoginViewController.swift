//
//  MeLoginViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 28/03/2022.
//

import UIKit
import FBSDKLoginKit

class MeLoginViewController: UIViewController {

    @IBOutlet weak var viewWelcome: UIView!
    @IBOutlet weak var loginFbBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!

    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        viewWelcome.layer.cornerRadius = 10
        skipBtn.layer.cornerRadius = 15
        loginFbBtn.layer.cornerRadius = 15


        updateButton(isLoggedIn: (AccessToken.current != nil))

        // Observe access token changes
        // This will trigger after successfully login / logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in

            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }

    @IBAction func skipBtnDidTap(_ sender: Any) {

        self.userDefault.set(true, forKey: "isLogin")
        //Change Root ViewController
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MainTabBarController(), loginVC: false)
    }

    @IBAction func loginFbBtnDidTap(_ sender: Any) {
        //1
        let loginManager = LoginManager()

        if let _ = AccessToken.current {
            //TODO
        } else {
            loginManager.logIn(permissions: [], from: self) { [weak self] result, error in
                //Check  for error
                guard error == nil else {
                    print(error!.localizedDescription)
                    self?.userDefault.set(false, forKey: "isLogin")
                    return
                }

                //Check for cancel
                guard let result = result, !result.isCancelled  else {
                    self?.userDefault.set(false, forKey: "isLogin")
                    print("User cancelled login")
                    return
                }

                //Successfully logged in
                self?.updateButton(isLoggedIn: true)
                self?.userDefault.set(true, forKey: "isLogin")

                //Change Root ViewController
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MainTabBarController(), loginVC: false)
            }
        }
    }
}

extension MeLoginViewController {

    private func updateButton(isLoggedIn: Bool) {
        // 1
        let title = isLoggedIn ? "Log out" : "Sign in with Facebook"
        loginFbBtn.setTitle(title, for: .normal)
    }
}
