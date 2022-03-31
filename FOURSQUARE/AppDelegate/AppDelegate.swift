//
//  AppDelegate.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 01/03/2022.
//

import UIKit
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)

        //if user is logges in before
        if UserDefaults.standard.bool(forKey: "isLogin") {
            window?.rootViewController = MainTabBarController()
            window?.makeKeyAndVisible()
        } else {
            //if user isn't logged in
            let vc = MeLoginViewController()
            window?.rootViewController = UINavigationController(rootViewController: vc)
            window?.makeKeyAndVisible()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func changeRootViewController(_ vc: UIViewController, animated: Bool = true, loginVC: Bool) {
        guard let window = self.window else {
            return
        }
        // change the root view controller to your specific view controller
        if loginVC {
            window.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            window.rootViewController = vc
        }

        // add animation
           UIView.transition(with: window,
                             duration: 0.5,
                             options: [.transitionFlipFromLeft],
                             animations: nil,
                             completion: nil)
    }
}


class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = .white

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage.init(systemName: "house"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage.init(systemName: "magnifyingglass"), tag: 0)

        let favVC = UINavigationController(rootViewController: FavouriteViewController())
        favVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage.init(systemName: "menucard.fill"), tag: 0)

        let meVC = UINavigationController(rootViewController: MeViewController())
        meVC.tabBarItem = UITabBarItem(title: "Me", image: UIImage.init(systemName: "person.crop.rectangle.fill"), tag: 0)

            setViewControllers([homeVC, searchVC, favVC, meVC], animated: true)
    }
}


