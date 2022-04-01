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

    }

    @IBAction func skipBtnDidTap(_ sender: Any) {
        self.userDefault.set(false, forKey: "isLogin")
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MainTabBarController(), loginVC: false)
    }

    @IBAction func loginFbBtnDidTap(_ sender: Any) {
        loginBtnClicked()
    }
}

extension MeLoginViewController {

    func loginBtnClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) {result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
                self.userDefault.set(false, forKey: "isLogin")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    self.userDefault.set(true, forKey: "isLogin")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                    //Change Root ViewController
                    (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(MainTabBarController(), loginVC: false)
                }
            } else {
                self.userDefault.set(false, forKey: "isLogin")
                print("Cacelled")
            }
        }
    }

    func getUserProfile(token: AccessToken?, userId: String?) {


            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]

                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                    } else {
                        print("Facebook Id: Not exists")
                    }

                    // Facebook First Name
                    if let facebookFirstName = data["first_name"] as? String {
                        print("Facebook First Name: \(facebookFirstName)")
                    } else {
                        print("Facebook First Name: Not exists")
                    }

                    // Facebook Middle Name
                    if let facebookMiddleName = data["middle_name"] as? String {
                        print("Facebook Middle Name: \(facebookMiddleName)")
                    } else {
                        print("Facebook Middle Name: Not exists")
                    }

                    // Facebook Last Name
                    if let facebookLastName = data["last_name"] as? String {
                        print("Facebook Last Name: \(facebookLastName)")
                    } else {
                        print("Facebook Last Name: Not exists")
                    }

                    // Facebook Name
                    if let facebookName = data["name"] as? String {
                        print("Facebook Name: \(facebookName)")
                    } else {
                        print("Facebook Name: Not exists")
                    }

                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")

                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                    } else {
                        print("Facebook Email: Not exists")
                    }

                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                } else {
                    print("Error: Trying to get user's info")
                }
            }
        }
}
