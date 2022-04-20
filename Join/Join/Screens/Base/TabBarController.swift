//
//  TabBarController.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        // Do any additional setup after loading the view.
    }


}

extension TabBarController {
    private func setTabBar() {
        let mainView = MainVC()
        let mainViewTabItem = UITabBarItem(
            title: "메인",
            image: UIImage(systemName: "chevron.backward"),
            selectedImage:  UIImage(systemName: "chevron.backward")
        )
        mainView.tabBarItem = mainViewTabItem
        let mainViewController = UINavigationController(rootViewController: mainView)

        let joinView = JoinVC()
        let joinViewTabItem = UITabBarItem(
            title: "번개참여",
            image: UIImage(systemName: "chevron.backward"),
            selectedImage: UIImage(systemName: "chevron.backward")
        )
        joinView.tabBarItem = joinViewTabItem
        let joinViewcontroller = UINavigationController(rootViewController: joinView)

        let profileView = ProfileVC()
        let profileViewTabItem = UITabBarItem(
            title: "프로필",
            image: UIImage(systemName: "chevron.backward"),
            selectedImage: UIImage(systemName: "chevron.backward")
        )
        profileView.tabBarItem = profileViewTabItem
        let profileViewController = UINavigationController(rootViewController: profileView)

        viewControllers = [mainViewController, joinViewcontroller, profileViewController]

    }
}
