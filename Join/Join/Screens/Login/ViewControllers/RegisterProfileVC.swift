//
//  RegisterProfileVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import Moya

class RegisterProfileVC: BaseViewController {

    private let titleFirstLabel = UILabel().then {
        $0.text = "친구가 나를 알아볼 수 있는"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let titleSecondLabel = UILabel().then {
        $0.text = "프로필 사진을 등록해 주세요.📸"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }

    private let profileImageView = UIImageView().then {
        $0.image = Image.profileDefault
        $0.layer.cornerRadius = 70
        $0.layer.masksToBounds = true
    }

    private let passButton = UIButton().then {
        $0.setTitleColor(.grayScale100, for: .normal)
        $0.setTitle("다음에 할래요", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Medium)
        $0.setUnderline()
        $0.addTarget(self, action: #selector(checkVendor), for: .touchUpInside)
    }

    private let changeProfileButton = UIButton().then {
        $0.setImage(Image.cameraButton, for: .normal)
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapChangeProfileButton), for: .touchUpInside)
    }

    private let guideButton = UIButton().then {
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale300, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.isEnabled = false
    }

    let picker = UIImagePickerController()

    private let authProvider = MoyaProvider<AuthServices>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        picker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        setNavigationBar(isHidden: false)
        setUpNavigation()
        setLeftBarButton()
    }
}

extension RegisterProfileVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            titleFirstLabel,
            titleSecondLabel,
            profileImageView,
            changeProfileButton,
            passButton,
            guideButton
        ])
        titleFirstLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
        }
        titleSecondLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleFirstLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleFirstLabel.snp.leading)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleSecondLabel.snp.bottom).offset(35)
            make.width.equalTo(140)
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
        changeProfileButton.snp.makeConstraints { (make) in
            make.size.equalTo(36)
            make.trailing.bottom.equalTo(self.profileImageView).inset(-1)
        }
        passButton.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(144)
            make.trailing.equalToSuperview().offset(-144)
        }
        // TODO: - 추가될 UI요소 constraint 설정하기
        guideButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
    }

    private func setUpNavigation() {
        title = "회원가입"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }

    private func bind() {
        // 사진 등록하고 회원가입시키기
        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = CompleteProfileVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        // 사진 안등록하고 회원가입 시키기

    }

    @objc func checkVendor() {
        if UserDefaults.standard.string(forKey: "social") == "kakao" {
            doKakaoSignUp()
            print("왜안되냐고")
        }
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


    @objc func doKakaoSignUp(){

        let signUpRequest = SocialSignUpRequest(id: KeychainHandler.shared.kakaoId, email: KeychainHandler.shared.email, userName: KeychainHandler.shared.username, serviceId: KeychainHandler.shared.serviceId, profileImgUrl: KeychainHandler.shared.profileImgUrl)
        print(signUpRequest)
        authProvider.rx.request(.kakaoLogin(param: signUpRequest))
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                if response.statusCode == 200 {
                    KeychainHandler.shared.accessToken = JSON(response.data)["data"].string!
                    let viewController = CompleteProfileVC()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }, onError: {[weak self] _ in
                print("server error")
            }, onCompleted: {

            }).disposed(by: disposeBag)
    }
}

extension RegisterProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
