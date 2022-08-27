//
//  LogoutPopupVC.swift
//  Join
//
//  Created by 이윤진 on 2022/08/27.
//

import UIKit

final class LogoutPopupVC: UIViewController {
    private let popupView = UIView().then {
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    private let imageView = UIImageView().then {
        $0.image = Image.cryingface
    }

    private let guideLabel = UILabel().then {
        $0.font = .minsans(size: 20, family: .Bold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }

    private let cancelButton = UIButton().then {
        $0.setImage(Image.logout_no, for: .normal)
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }

    private let admitButton = UIButton().then {
        $0.setImage(Image.logout_yes, for: .normal)
        $0.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }

    weak var delegate: popupHandlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    init(_ text: String, _ status: String ){
        super.init(nibName: nil, bundle: nil)
        guideLabel.text = text
        if(status == "logout") {
            admitButton.setImage(Image.logout_yes, for: .normal)
        }
        if(status == "withdraw") {
            admitButton.setImage(Image.withdrawBtn, for: .normal)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(popupView)
        popupView.add(guideLabel)
        popupView.add(imageView)
        popupView.add(admitButton)
        popupView.add(cancelButton)

        popupView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(260)
            make.width.equalTo(327)
            make.height.equalTo(284)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }

        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(popupView)
            make.leading.equalTo(popupView).offset(123)
            make.trailing.equalTo(popupView).offset(-123)
            make.top.equalTo(popupView).offset(35)
            make.size.equalTo(80)
        }
        guideLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.equalTo(popupView).offset(75)
            make.centerX.equalTo(popupView)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalTo(popupView).offset(24)
            make.bottom.equalTo(popupView).offset(-24)
            make.width.equalTo(136)
            make.height.equalTo(56)
        }

        admitButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(popupView).offset(-24)
            make.bottom.equalTo(popupView).offset(-24)
            make.width.equalTo(136)
            make.height.equalTo(56)
        }


    }

    @objc private func doneButtonDidTap() {
        self.dismiss(animated: true) {
            self.delegate?.handlerDidTap()
        }
    }
    @objc private func cancelButtonDidTap() {
        let time = DispatchTime.now() + .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

protocol popupHandlerDelegate: AnyObject {
    func handlerDidTap()
}

