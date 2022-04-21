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
        // 임시로 만들어놓은 탭바 컨트롤러
        // 보통 탭바 커스텀시에 코드를 많이 사용하길래
        // 스토리보드 대신 코드로 연결을 해놓았습니다.
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
