//
//  MakeDetailVC.swift
//  Join
//
//  Created by 홍정민 on 2022/05/12.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard


class MakeDetailVC: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    
}

extension MakeDetailVC {
    private func setLayout() {
        setTabBarHidden(isHidden: true)
        setNavigationBar(isHidden: false)
        setNavigationName(title: "번개작성")
        view.backgroundColor = .green
        
    }
    
    private func bind(){
//        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
//            guard let self = self else { return }
//            self.nextButton.layer.cornerRadius = 0
//            self.nextButton.snp.updateConstraints{
//                $0.leading.trailing.equalToSuperview().offset(0)
//            }
//
//            UIView.animate(withDuration: 0) {
//                if keyboardHeight == 0 {
//                    self.nextButton.snp.updateConstraints { make in
//                        make.bottom.equalToSuperview().offset(-30)
//                    }
//                } else {
//                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
//                    self.nextButton.snp.updateConstraints { (make) in
//                        make.bottom.equalToSuperview().offset(-totalHeight+(-30))
//                    }
//                }
//                self.view.layoutIfNeeded()
//            }
//        }).disposed(by: disposeBag)
        
    }
}
