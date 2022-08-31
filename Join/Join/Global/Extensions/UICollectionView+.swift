//
//  UICollectionView+.swift
//  Join
//
//  Created by 홍정민 on 2022/08/31.
//

import Foundation
import UIKit
import SnapKit
import Then


extension UICollectionView {
    
    
    func setEmptyView() {
        
        //사이즈 조정
        var width = self.frame.width
        var height = self.frame.height
        let midY = self.frame.midY
        let midX = self.frame.midX
        
        
        if UIDevice.current.isiPhone8 {
            width = width * 0.65
            height = height * 0.55
        }else {
            width = width * 0.701
            height = height * 0.51
        }
        
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        
        let subView: UIView = {
            let view = UIView()
            return view
        }()
        
        let titleLabel = UILabel().then {
            $0.text = "참여할 번개글이 없어요."
            $0.textColor = UIColor.grayScale600
            $0.font = .minsans(size: 15, family: .Medium)
        }
        

        emptyView.adds([subView, titleLabel])

        subView.frame = CGRect(x: (self.frame.width-width)/2 , y: midY-(height/2)+40, width: width, height: height)
        
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(subView.snp.centerY)
            $0.centerX.equalTo(subView.snp.centerX)
        }
                
        subView.addLineDashedStroke(radius: 35, color: "green")

        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
   
    
}
