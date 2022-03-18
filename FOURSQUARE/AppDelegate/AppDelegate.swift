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

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage.init(systemName: "magnifyingglass"), tag: 0)

        let listVC = UINavigationController(rootViewController: ListViewController())
        listVC.tabBarItem = UITabBarItem(title: "Lists", image: UIImage.init(systemName: "list.bullet"), tag: 0)

        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage.init(systemName: "menucard.fill"), tag: 0)

        let meVC = UINavigationController(rootViewController: MeViewController())
        meVC.tabBarItem = UITabBarItem(title: "Me", image: UIImage.init(systemName: "person.crop.rectangle.fill"), tag: 0)

        setViewControllers([homeVC, listVC, historyVC, meVC], animated: true)
    }
}


