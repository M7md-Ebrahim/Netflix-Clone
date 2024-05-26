//
//  ViewController.swift
//  Netflix Clone
//
//  Created by M7md  on 13/12/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label

        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let upcomingViewController = UINavigationController(rootViewController: UpcomingViewController())
        upcomingViewController.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "play.circle"), selectedImage: UIImage(systemName: "play.circle.fill"))
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "Top Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        let watchlistViewController = UINavigationController(rootViewController: WatchlistViewController())
        watchlistViewController.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName: "stopwatch.fill"))
        setViewControllers([homeViewController, upcomingViewController, searchViewController, watchlistViewController], animated: true)
    }
}
