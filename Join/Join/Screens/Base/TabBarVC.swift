//
//  TabBarVC.swift
//  Join
//
//  Created by 홍정민 on 2022/04/25.
//

import UIKit

class TabBarVC: UITabBar {
    
    override func draw(_ rect: CGRect) {
        self.unselectedItemTintColor = UIColor.gray
        self.tintColor = UIColor.darkGray
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
}
