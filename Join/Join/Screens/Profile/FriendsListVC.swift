//
//  FriendsListVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/14.
//

import UIKit

class FriendsListVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setTabBarHidden(isHidden: true)
    }

}

extension FriendsListVC {

    private func setUpNavigation() {
        title = "내 친구"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isTranslucent = false

    }
}
