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
    
    private let mentLabel = UILabel().then {
        $0.text = "마지막으로\n자세히 설명해 주세요!"
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let subDesciptionLabel = UILabel().then {
        $0.text = "설명 (선택)"
    }
    
    private let descriptionTextView = UITextView().then {
        $0.tintColor = .black
        $0.layer.cornerRadius = 20
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.backgroundColor = .gray
        $0.becomeFirstResponder()
    }
    
    private let descriptionLengthLabel = UILabel().then {
        $0.text = "0/100"
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("번개 등록", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    
}

extension MakeDetailVC {
    private func setLayout() {
        setNavigationBar(isHidden: false)
        setNavigationName(title: "번개작성")
        
        view.adds([mentLabel
                  ,subDesciptionLabel
                  ,descriptionTextView
                  ,descriptionLengthLabel
                  ,nextButton])
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(72)
        }
        
        
        subDesciptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(mentLabel)
            $0.top.equalTo(mentLabel.snp.bottom).offset(23)
        }
        
        
        descriptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalTo(mentLabel)
            $0.top.equalTo(subDesciptionLabel.snp.bottom).offset(8)
            $0.height.equalTo(154)
        }
        
        descriptionLengthLabel.snp.makeConstraints {
            $0.trailing.equalTo(mentLabel)
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(8)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    private func bind(){
        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
            guard let self = self else { return }
            self.nextButton.layer.cornerRadius = 0
            self.nextButton.snp.updateConstraints{
                $0.leading.trailing.equalToSuperview().offset(0)
            }

            UIView.animate(withDuration: 0) {
                if keyboardHeight == 0 {
                    self.nextButton.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-30)
                    }
                } else {
                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    self.nextButton.snp.updateConstraints { (make) in
                        make.bottom.equalToSuperview().offset(-totalHeight+(-30))
                    }
                }
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.nextButton.layer.cornerRadius = 20
        self.nextButton.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}
