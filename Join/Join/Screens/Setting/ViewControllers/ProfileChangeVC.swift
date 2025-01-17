//
//  ProfileChangeVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/30.
//

import UIKit

import Moya
import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard

class ProfileChangeVC: BaseViewController {

    private let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let profileImageView = UIImageView().then {
        $0.image = Image.profileDefault
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private let changeProfileButton = UIButton().then {
        $0.setImage(Image.cameraButton, for: .normal)
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapChangeProfileButton), for: .touchUpInside)
    }

    private let userNameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }

    private let nameTextField = UITextField().then {
        $0.placeholder = "현재 이름"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("변경", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.isEnabled = false
        // API 변경예정
        $0.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
    }

    let picker = UIImagePickerController()

    private let profileProvider = MoyaProvider<ProfileServices>()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = true
        setLayout()
        setTextField()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setTabBarHidden(isHidden: true)
    }
}

extension ProfileChangeVC {

    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            profileLabel,
            profileImageView,
            changeProfileButton,
            userNameLabel,
            nameTextField,
            guideButton
        ])
        profileLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(21)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(47)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        changeProfileButton.snp.makeConstraints { (make) in
            make.size.equalTo(36)
            make.trailing.bottom.equalTo(self.profileImageView).inset(-1)
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalTo(profileLabel.snp.leading)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(userNameLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(327)
            make.height.equalTo(56)
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
        title = "프로필 수정"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }

    private func setTextField() {
        nameTextField.delegate = self
    }
    private func bind() {
        RxKeyboard.instance.visibleHeight.drive(onNext: {[weak self] keyboardHeight in
            guard let self = self else { return }
            UIView.animate(withDuration: 0) {
                if keyboardHeight == 0 {
                    self.guideButton.layer.cornerRadius = 16
                    self.guideButton.snp.updateConstraints { make in
                        make.leading.equalToSuperview().offset(24)
                        make.trailing.equalToSuperview().offset(-24)
                        make.bottom.equalToSuperview().offset(-30)
                    }
                } else {
                    self.guideButton.layer.cornerRadius = 0
                    let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    self.guideButton.snp.updateConstraints { (make) in
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                        make.bottom.equalToSuperview().offset(-totalHeight+(-30))
                    }
                }
                self.view.layoutIfNeeded()
            }
        })
        .disposed(by: disposeBag)


    }

    @objc func didTapChangeProfileButton() {
        let alert = UIAlertController()
        let library = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in self.openLibrary() }
        let delete = UIAlertAction(title: "프로필 사진 삭제", style: .default) { _ in self.deletePhoto() }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.view.tintColor = .grayScale900
        present(alert, animated: true, completion: nil)
    }

    private func deletePhoto() {
        profileImageView.image = Image.profileDefault
        guideButton.isEnabled = false
        guideButton.backgroundColor = .grayScale500
        guideButton.setTitleColor(.grayScale300, for: .normal)
    }

    private func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }

    @objc func changeProfile() {
        profileProvider.rx.request(.changeImage(image: profileImageView.image ?? UIImage()))
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                let msg = JSON(response.data)["message"]
                print(msg)

                if response.statusCode == 200 {
                    //print(message)
                }
            }, onError: {[weak self] _ in
                print("err occured")
            }).disposed(by: self.disposeBag)
    }
}

extension ProfileChangeVC: UITextFieldDelegate {
    @objc private func checkInput(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 0 {
            textField.layer.borderColor = UIColor.grayScale400.cgColor
            textField.layer.cornerRadius = 20
            textField.layer.borderWidth = 2.0
            guideButton.isEnabled = true
            guideButton.backgroundColor = .yellow200
            guideButton.setTitleColor(.grayScale900, for: .normal)
        } else {
            textField.layer.borderWidth = 0.0
            guideButton.isEnabled = false
            guideButton.backgroundColor = .grayScale500
            guideButton.setTitleColor(.grayScale300, for: .normal)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ProfileChangeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = image
            guideButton.isEnabled = true
            guideButton.backgroundColor = .yellow200
            guideButton.setTitleColor(.grayScale900, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
