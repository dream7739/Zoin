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
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
        $0.numberOfLines = 0
    }
    
    private let subDesciptionLabel = UILabel().then {
        $0.text = "설명 (선택)"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let descriptionTextView = UITextView().then {
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
    }
    
    private let descriptionLengthLabel = UILabel().then {
        $0.text = "0/100"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
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
        
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        
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
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let makeCompleteVC = MakeCompleteVC()
                self.navigationController?.pushViewController(makeCompleteVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
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
                    let totalHeight = keyboardHeight
                    self.nextButton.snp.updateConstraints { (make) in
                        make.bottom.equalToSuperview().offset(-totalHeight)
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
