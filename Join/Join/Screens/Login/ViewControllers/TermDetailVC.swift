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
    var index = 0
    
    private let titleLabel = UILabel().then {
        $0.text = "개인정보 수집 및 이용 동의 (필수)"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Bold)
    }
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private let contentView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "수집한 개인정보의 이용\n네이버 및 네이버 관련 제반 서비스(모바일 웹/앱 포함)의 회원관리, 서비스 개발·제공 및 향상, 안전한 인터넷 이용환경 구축 등 아래의 목적으로만 개인정보를 이용합니다.\n\n회원 가입 의사의 확인, 연령 확인 및 법정대리인 동의 진행, 이용자 및 법정대리인의 본인 확인, 이용자 식별, 회원탈퇴 의사의 확인 등 회원관리를 위하여 개인정보를 이용합니다.\n콘텐츠 등 기존 서비스 제공(광고 포함)에 더하여, 인구통계학적 분석, 서비스 방문 및 이용기록의 분석, 개인정보 및 관심에 기반한 이용자간 관계의 형성, 지인 및 관심사 등에 기반한 맞춤형 서비스 제공 등 신규 서비스 요소의 발굴 및 기존 서비스 개선 등을 위하여 개인정보를 이용합니다.\n법령 및 네이버 이용약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재, 계정도용 및 부정거래 방지, 약관 개정 등의 고지사항 전달, 분쟁조정을 위한 기록 보존, 민원처리 등 이용자 보호 및 서비스 운영을 위하여 개인정보를 이용합니다.\n유료 서비스 제공에 따르는 본인인증, 구매 및 요금 결제, 상품 및 서비스의 배송을 위하여 개인정보를 이용합니다.\n 이벤트 정보 및 참여기회 제공, 광고성 정보 제공 등 마케팅 및 프로모션 목적으로 개인정보를 이용합니다.\n 서비스 이용기록과 접속 빈도 분석, 서비스 이용에 대한 통계, 서비스 분석 및 통계에 따른 맞춤 서비스 제공 및 광고 게재 등에 개인정보를 이용합니다.\n보안, 프라이버시, 안전 측면에서 이용자가 안심하고 이용할 수 있는 서비스 이용환경 구축을 위해 개인정보를 이용합니다."
        $0.textColor = .grayScale100
        $0.numberOfLines = 0
        $0.font = .minsans(size: 14, family: .Regular)
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
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        contentScrollView.backgroundColor = .grayScale900
        contentScrollView.isOpaque = true
        
        view.adds([titleLabel, contentScrollView])
        contentScrollView.add(contentView)
        contentView.add(contentLabel)
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(8)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(contentScrollView.snp.width)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(contentScrollView).inset(24)
        }
        
        let attributedString = NSMutableAttributedString(string: self.titleLabel.text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (self.titleLabel.text! as NSString as NSString).range(of:"(필수)"))
        self.titleLabel.attributedText = attributedString
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
