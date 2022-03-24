//
//  AppDelegate.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 01/03/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}

class TabBarController: UITabBarController {

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


