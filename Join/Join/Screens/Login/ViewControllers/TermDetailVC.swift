//
//  TermDetailVC.swift
//  Join
//
//  Created by 홍정민 on 2022/07/05.
//


import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya


class TermDetailVC: BaseViewController {
    var isAllTermBtnClicked = false
    var agreeCount = 0
    
    private let titleLabel = UILabel().then {
        $0.text = "쪼인 이용에 필요한\n약관에 동의해 주세요. 📝"
        $0.numberOfLines = 0
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }
    
    
    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("전체동의하고 다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }
}

extension TermDetailVC {
    private func setLayout() {
    }
        
      
    
    private func setUpNavigation() {
        title = "회원가입"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
    
    private func bind() {

    }
}
