//
//  JoinVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON


protocol FinishMainDelegate {
    func finishMainUpdate() //번개 마감시 액션을 정의함
    func mainReloadView()  // 번개 상세모달이 닫힐 때 호출자 업데이트 
}

class JoinVC: BaseViewController {
    private let makeProvider = MoyaProvider<MakeServices>()

    var atndFlag = false //참여여부 플래그
    var joinType: Bool! //true - 내 번개, false - 친구번개
    var isCanceled = false
    var isDeleted = false
    var viewTranslation:CGPoint = CGPoint(x: 0, y: 0)
    var delegate: FinishMainDelegate?
    var popupViewTopConstraint: Constraint? = nil
    var item: MainElements!

    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale900
        $0.layer.cornerRadius = 40
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    let btnStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    
    var indicatorLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale600
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    
    var profileImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile")
    }
    
    var moreBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setBackgroundImage(UIImage(named: "icon_more"), for: .normal)
    }
    
    var timeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_time1")
    }
    
    var placeImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_place1")
    }
    
    var attendImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_attend1")
    }
    
    var nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 16, family: .Bold)
        $0.textColor = .grayScale100
    }
    
    var idLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale500
    }
    
    var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale100
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 24, family: .Bold)
        $0.textColor = .grayScale100
    }
    
    var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale100
    }
    
    var placeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textColor = .grayScale100
    }
    
    var lineImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale800
    }
    
    var contentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .minsans(size: 16, family: .Regular)
        $0.textColor = .grayScale100
    }
    
    var attendLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "참여중"
        $0.backgroundColor  = .pink100
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.font = .minsans(size: 12, family: .Bold)
        $0.textAlignment = .center
        $0.isHidden = true //초기에 보이지 않다가 참여 액션이 있을 때 보임
    }
    
    var joinBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("참여하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    var attendConfirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("참여자 확인하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    var finishBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("마감하기", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    
}


//번개 수정 시
extension JoinVC: ModifyDelegate {
    func modifyFinish(item: MainElements) {
        self.item = item
        viewBind()
    }
    
}


extension JoinVC: CancelDelegate, FinishDelegate {
    func cancelUpdate(isCanceled: Bool) {
        if(isCanceled){
            self.isCanceled = isCanceled
            self.showToast(message: "번개 참여가 취소되었어요.")
        }
    }
    
    func finishUpdate() {
        dismiss(animated: true, completion: {
            self.delegate?.finishMainUpdate() //메인에서 팝업 노출
        })
    }
    
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.8)
        
        view.add(popupView)
        
        btnStackView.addArrangedSubview(attendConfirmBtn)
        btnStackView.addArrangedSubview(finishBtn)
        
        popupView.adds([
            indicatorLabel,
            profileImg,
            moreBtn,
            timeImg,
            placeImg,
            attendImg,
            nameLabel,
            idLabel,
            countLabel,
            titleLabel,
            dateLabel,
            placeLabel,
            lineImage,
            contentLabel,
            attendLabel,
            joinBtn,
            btnStackView
        ])
        
        
        if !joinType {
            moreBtn.isHidden = true
            btnStackView.isHidden = true
        }else{
            joinBtn.isHidden = true
        }
        
        
        //dismiss gesture 추가
        viewTranslation = CGPoint(x: popupView.frame.minX, y: popupView.frame.minY)
        
        popupView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: #selector(handleDismiss)))
        
        popupView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            popupViewTopConstraint = $0.top.equalToSuperview().offset(131).constraint
            
        }
        
        indicatorLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(48)
            $0.height.equalTo(6)
            
        }
        
        profileImg.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(24)
        }
        
        moreBtn.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(profileImg)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        timeImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        placeImg.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(15.9)
            $0.leading.equalTo(timeImg.snp.leading)
            $0.top.equalTo(timeImg.snp.bottom).offset(12)
        }
        
        attendImg.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalTo(placeImg.snp.leading)
            $0.top.equalTo(placeImg.snp.bottom).offset(12)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg)
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.leading)
            $0.top.equalTo(profileImg.snp.bottom).offset(32)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImg.snp.trailing).offset(12)
            $0.centerY.equalTo(timeImg.snp.centerY)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.centerY.equalTo(placeImg.snp.centerY)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.centerY.equalTo(attendImg.snp.centerY)
        }
        
        lineImage.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(attendImg.snp.bottom).offset(16)
            $0.leading.equalTo(attendImg.snp.leading)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineImage.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(lineImage)
        }
        
        attendLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalToSuperview().offset(64)
            $0.width.equalTo(53)
            $0.height.equalTo(26)
        }
        
        joinBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-45)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
        
        btnStackView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-46)
            $0.leading.equalTo(contentLabel.snp.leading)
            $0.trailing.equalTo(contentLabel.snp.trailing)
            $0.height.equalTo(56)
        }
    }
    
    private func viewBind(){
        nameLabel.text = item.creator.userName
        idLabel.text = "@\(item.creator.serviceId)"
        titleLabel.text = item.title
        
        let dateStr = item.appointmentTime
        item.appointmentTime = dateStr
        dateLabel.text = dateStr.dateTypeChange(dateStr: dateStr)
        
        //오늘 강조 처리
        let attributedStr = NSMutableAttributedString(string: self.dateLabel.text!)
        attributedStr.addAttribute(.font, value: UIFont.minsans(size: 14, family: .Bold)!, range: (self.dateLabel.text! as NSString).range(of: "오늘"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (self.dateLabel.text! as NSString).range(of: "오늘"))
        dateLabel.attributedText = attributedStr
        
        placeLabel.text = item.location
        countLabel.text = "\(item.participants.count)/\(item.requiredParticipantsCount)"
        contentLabel.text = item.description
    }
    
    private func bind(){
        viewBind()
        
        joinBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if(!(self!.atndFlag)){
                    //토스트 출력 & 참여중 라벨 표시 & 참여취소로 버튼 변경
                    self?.joinBtn.backgroundColor = .grayScale500
                    self?.joinBtn.setTitleColor(.grayScale300, for: .normal)
                    self?.attendLabel.isHidden = false
                    self?.atndFlag = true
                    self?.showToast(message: "친구 번개에 참여했어요!")
                }else{
                    self?.clickCancelBtn()
                }
            })
            .disposed(by: disposeBag)
        
        
        finishBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.clickFinishBtn()
            })
            .disposed(by: disposeBag)
        
        
        attendConfirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.clickAttendConfirmBtn()
            })
            .disposed(by: disposeBag)
        
        
        moreBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.joinType {
                    //actionSheet 출력 (수정/삭제)
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let modify = UIAlertAction(title: "수정", style: .default, handler: {_ in
                        let joinModifyVC = JoinModifyVC()
                        joinModifyVC.item = self.item
                        joinModifyVC.delegate = self
                        joinModifyVC.modalPresentationStyle = .fullScreen
                        self.present(joinModifyVC, animated: true)
                    })
                    let delete = UIAlertAction(title: "삭제", style: .default, handler: {_ in
                        //삭제 서버 통신
                        self.deleteRendezvous()
                    })
                    
                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    alert.addAction(modify)
                    alert.addAction(delete)
                    
                    alert.view.tintColor = .grayScale900
                    self.present(alert, animated: true)
                    
                }else{
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func deleteRendezvous() {
        makeProvider.rx.request(.deleteRendezvous(id: self.item.id))
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                let status = JSON(response.data)["status"]
                if status == 200 {
                    self?.isDeleted = true
                    self?.showToast(message: "번개가 삭제되었어요")
                    print("delete success: \(self!.item.id)")
                }else{
                    print("\(status)")
                }
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.popupView)
            if(self.view.frame.minY < self.viewTranslation.y){
                let newPosition = 131 + self.viewTranslation.y
                self.popupView.snp.updateConstraints{
                    self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(newPosition).constraint
                }
            }
            
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.popupView.snp.updateConstraints{
                        self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(131).constraint
                    }
                })
            } else {
                dismiss(animated: true, completion: nil)
                self.delegate?.mainReloadView()
            }
        default:
            break
        }
    }
    
    private func clickCancelBtn(){
        let joinCancelVC = JoinCancelVC()
        joinCancelVC.delegate = self
        joinCancelVC.modalPresentationStyle = .overFullScreen
        self.present(joinCancelVC, animated: true)
    }
    
    private func clickFinishBtn(){
        let joinFinishVC = JoinFinishVC()
        joinFinishVC.delegate = self
        joinFinishVC.modalPresentationStyle = .overFullScreen
        self.present(joinFinishVC, animated: true)
    }
    
    private func clickAttendConfirmBtn(){
        let joinMemberConfirmVC = JoinMemberConfirmVC()
        joinMemberConfirmVC.modalPresentationStyle = .overFullScreen
        self.present(joinMemberConfirmVC, animated: true)
    }
    
    
    private func showToast(message : String){
        let toastView = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 16
            
            if self.isCanceled || self.isDeleted {
                $0.backgroundColor = .grayScale200
            }else{
                $0.backgroundColor = .yellow50
            }
            
        }
        
        let toastLabel = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .minsans(size: 14, family: .Bold)
            $0.text = message
            
            if self.isCanceled || self.isDeleted {
                $0.textColor = .grayScale800
            }else{
                $0.textColor = .orange100
            }
        }
        
        let toastIcon = UIImageView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            if self.isCanceled || self.isDeleted {
                $0.image = UIImage(named: "icon_cancel")
            }else{
                $0.image = UIImage(named: "icon_thunder1")
            }
        }
        
        toastView.adds([toastLabel, toastIcon])
        popupView.add(toastView)
        
        toastView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(joinBtn.snp.top).offset(-10)
        }
        
        toastIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
            $0.width.equalTo(14)
            $0.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints {
            $0.leading.equalTo(toastIcon.snp.trailing).offset(13)
            $0.centerY.equalTo(toastIcon.snp.centerY)
        }
        
        
        UIView.animate(withDuration: 1.5, delay: 0.01, options: .curveEaseInOut, animations: {
            toastView.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
            if self.isCanceled {
                self.joinBtn.backgroundColor = .yellow200
                self.joinBtn.setTitleColor(.grayScale800, for: .normal)
                self.joinBtn.setTitle("참여하기", for: .normal)
                self.attendLabel.isHidden = true
                self.moreBtn.isHidden = false
            }else if self.isDeleted {
                self.dismiss(animated: true, completion: nil)
            }else {
                self.joinBtn.backgroundColor = .grayScale800
                self.joinBtn.setTitleColor(.grayScale100, for: .normal)
                self.joinBtn.setTitle("참여취소", for: .normal)
            }
            
        })
        
    }
    
    
    
    
}

