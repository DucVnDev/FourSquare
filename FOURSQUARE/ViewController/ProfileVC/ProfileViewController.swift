import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {


    @IBOutlet weak var imageUserImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"

        updateButton(isLoggedIn: (AccessToken.current != nil))

        getUserProfile(token: AccessToken.current, userId: AccessToken.current?.userID)
    }

    @IBAction func logOutBtnDidTap(_ sender: Any) {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
            UserDefaults.standard.set(false, forKey: "isLogin")
            print(UserDefaults.standard.bool(forKey: "isLogin"))
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(LoginViewController(), loginVC: true)
        } else {
            //TODO
            UserDefaults.standard.set(true, forKey: "isLogin")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(LoginViewController(), loginVC: true)
        }
    }

}

extension ProfileViewController {
    private func updateMessage(with name: String?) {
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

    private func getUserProfile(token: AccessToken?, userId: String?) {

            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, email "])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]

                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                        self.idLabel.text = facebookId
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
                        self.userName.text = facebookName
                    } else {
                        print("Facebook Name: Not exists")
                    }

                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")

                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                        self.emailLabel.text = facebookEmail
                        self.emailLabel.textColor = .black
                    } else {
                        print("Facebook Email: Not exists")
                    }
                    
                    print("Facebook Access Token: \(AccessToken.current!)")
                } else {
                    print("Error: Trying to get user's info")
                }
            }
        }
}
