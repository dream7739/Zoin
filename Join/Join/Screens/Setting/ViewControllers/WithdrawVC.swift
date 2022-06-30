//
//  WithdrawVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/30.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya

class WithdrawVC: BaseViewController {

    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .grayScale900
    }

    private let titleLabel = UILabel().then {
        $0.text = "탈퇴 사유를"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "선택해 주세요.😢"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let firstButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let secondButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let thirdButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let fourthButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let fifthButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let sixthButton = UIButton().then {
        $0.setImage(Image.checkbox, for: .normal)
        $0.layer.masksToBounds = true
    }

    private let firstLabel = UILabel().then {
        $0.text = "참여할 번개가 없어요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let secondLabel = UILabel().then {
        $0.text = "번개를 울리지 않게 돼요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let thirdLabel = UILabel().then {
        $0.text = "앱을 사용하는 주변 사람들이 많지 않아요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let fourthLabel = UILabel().then {
        $0.text = "앱에 오류가 자주 발생해요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let fifthLabel = UILabel().then {
        $0.text = "불쾌한 경험을 했어요"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let sixthLabel = UILabel().then {
        $0.text = "기타"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
    }

    private let reasonTextView = UITextView().then {
        $0.text =
            """
            탈퇴 사유를 입력해 주세요.
            서비스 개선에 적극적으로 반영할게요!
            """
        $0.textColor = .grayScale600
        $0.tintColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.layer.cornerRadius = 20
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale300, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("탈퇴", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTextView()
        //bind()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setTabBarHidden(isHidden: true)
    }


}

extension WithdrawVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.add(scrollView)
        scrollView.add(contentView)
        contentView.adds([
            titleLabel,
            titleSecondLabel,
            firstButton,
            firstLabel,
            secondButton,
            secondLabel,
            thirdButton,
            thirdLabel,
            fourthButton,
            fourthLabel,
            fifthButton,
            fifthLabel,
            sixthButton,
            sixthLabel,
            reasonTextView,
            guideButton
        ])
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalTo(self.view)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(24)
        }
        titleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.width.equalTo(250)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        firstButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(42)
            make.leading.equalTo(titleSecondLabel.snp.leading)
            make.size.equalTo(20)
        }
        firstLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(firstButton.snp.trailing).offset(8)
            make.top.equalTo(firstButton.snp.top)
        }
        secondButton.snp.makeConstraints { (make) in
            make.leading.equalTo(firstButton.snp.leading)
            make.top.equalTo(firstButton.snp.bottom).offset(30)
            make.size.equalTo(20)
        }
        secondLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(secondButton.snp.trailing).offset(8)
            make.top.equalTo(secondButton.snp.top)
        }
        thirdButton.snp.makeConstraints { (make) in
            make.leading.equalTo(secondButton.snp.leading)
            make.top.equalTo(secondButton.snp.bottom).offset(30)
            make.size.equalTo(20)
        }
        thirdLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(thirdButton.snp.trailing).offset(8)
            make.top.equalTo(thirdButton.snp.top)
        }
        fourthButton.snp.makeConstraints { (make) in
            make.leading.equalTo(thirdButton.snp.leading)
            make.top.equalTo(thirdButton.snp.bottom).offset(30)
            make.size.equalTo(20)
        }
        fourthLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(fourthButton.snp.trailing).offset(8)
            make.top.equalTo(fourthButton.snp.top)
        }
        fifthButton.snp.makeConstraints { (make) in
            make.leading.equalTo(fourthButton.snp.leading)
            make.top.equalTo(fourthButton.snp.bottom).offset(30)
            make.size.equalTo(20)
        }
        fifthLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(fifthButton.snp.trailing).offset(8)
            make.top.equalTo(fifthButton.snp.top)
        }
        sixthButton.snp.makeConstraints { (make) in
            make.leading.equalTo(fifthButton.snp.leading)
            make.top.equalTo(fifthButton.snp.bottom).offset(30)
            make.size.equalTo(20)
        }
        sixthLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(sixthButton.snp.trailing).offset(8)
            make.top.equalTo(sixthButton.snp.top)
        }
        reasonTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(sixthButton.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(155)
            make.top.equalTo(sixthLabel.snp.bottom).offset(8)
        }
        guideButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
    }

    private func setUpNavigation() {
        title = "회원 탈퇴"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isTranslucent = false
    }

    private func setTextView() {
        reasonTextView.delegate = self
    }

    private func bind(){
        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
            guard let self = self else { return }
            UIView.animate(withDuration: 0) {
                if keyboardHeight == 0 {
                    //                    self.guideButton.layer.cornerRadius = 16
                    self.scrollView.snp.updateConstraints { make in
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                        make.bottom.equalToSuperview()
                    }
                } else {
                    //                    self.guideButton.layer.cornerRadius = 0
                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    self.scrollView.snp.updateConstraints { (make) in
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                        make.bottom.equalToSuperview().offset(-totalHeight)
                    }
                }
                self.view.layoutIfNeeded()
            }
        })
        .disposed(by: disposeBag)
    }
}

extension WithdrawVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if text ==
            """
            탈퇴 사유를 입력해 주세요.
            서비스 개선에 적극적으로 반영할게요!
            """ {
            textView.text = ""
            textView.textColor = .yellow200
            if text.count > 0 {
                textView.layer.borderColor = UIColor.grayScale400.cgColor
                textView.layer.cornerRadius = 20
                textView.layer.borderWidth = 2.0
            } else {
                textView.layer.borderWidth = 0.0
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentView.endEditing(true)
    }
}
