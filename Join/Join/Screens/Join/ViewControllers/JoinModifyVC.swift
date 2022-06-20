//
//  JoinModifyVC.swift
//  Join
//
//  Created by 홍정민 on 2022/06/14.
//


import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard

class JoinModifyVC: BaseViewController {
    let textViewPlaceHolder = "나의 번개를 마구 어필해도 좋아요"
    
    private let mentLabel = UILabel().then {
        $0.text = "번개수정"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 18, family: .Bold)
        $0.numberOfLines = 0
    }
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .grayScale800
        return scrollView
    }()
    
    
    private let contentView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private let closeBtn = UIButton().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setBackgroundImage(UIImage(named: "icon_close"), for: .normal)
    }
    
    
    //제목 stackView
    let titleStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    //날짜 stackView
    let dateStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    //장소 stackView
    let placeStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    //인원 stackView
    let participantView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //설명 stackView
    let descriptionStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    //전체 stackView
    let entireStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 16
    }
    
    //제목
    private let subTitleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목입력"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    
    private let titleLengthLabel = UILabel().then {
        $0.text = "0/30"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
        $0.textAlignment = .right
    }
    
    //날짜
    private let subDateLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let dateTextField = UITextField().then {
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    
    
    //장소
    private let subPlaceLabel = UILabel().then {
        $0.text = "장소"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let placeTextField = UITextField().then {
        $0.placeholder = "구체적인 만날 장소를 입력해 주세요"
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    
    
    //참여인원
    private let subParticipantLabel = UILabel().then {
        $0.text = "참여 인원"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let participantTextField = UITextField().then {
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    
    private let participantLabel = UILabel().then {
        $0.text = "명"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 16, family: .Medium)
        $0.textAlignment = .left
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    
    //시간 선택 팝업
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    var datePopupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    var popUpLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "약속시간을 선택해주세요"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    var joinDatePicker = UIDatePicker().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.datePickerMode = .dateAndTime
        $0.timeZone = NSTimeZone.local
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
        $0.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    
    var resetBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.setTitle("상관없음", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    
    private let subDesciptionLabel = UILabel().then {
        $0.text = "설명 (선택)"
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    private let descriptionTextView = UITextView().then {
        $0.tintColor = .yellow200
        $0.textColor = .grayScale600
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right:16.0)
    }
    
    private let descriptionLengthLabel = UILabel().then {
        $0.text = "0/100"
        $0.textColor = .grayScale100
        $0.textAlignment = .right
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    
    
    var confirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("다음", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarHidden(isHidden: true)
        titleTextField.becomeFirstResponder()
        titleTextField.text = ""
        dateTextField.text = ""
        placeTextField.text = ""
        participantTextField.text = ""
        descriptionTextView.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dateStackView.removeFromSuperview()
        placeStackView.removeFromSuperview()
        participantView.removeFromSuperview()
        descriptionStackView.removeFromSuperview()
    }
}

extension JoinModifyVC {
    
    private func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        contentScrollView.backgroundColor = .grayScale900
        contentScrollView.isOpaque = true
        
        view.adds([mentLabel, closeBtn, contentScrollView, nextButton])
        
        contentScrollView.add(contentView)
        contentView.add(entireStackView)
        
        
        entireStackView.addArrangedSubview(titleStackView)
        entireStackView.addArrangedSubview(dateStackView)
        entireStackView.addArrangedSubview(placeStackView)
        entireStackView.addArrangedSubview(participantView)
        entireStackView.addArrangedSubview(descriptionStackView)
        
        
        titleStackView.addArrangedSubview(subTitleLabel)
        titleStackView.addArrangedSubview(titleTextField)
        titleStackView.addArrangedSubview(titleLengthLabel)
        
        dateStackView.addArrangedSubview(subDateLabel)
        dateStackView.addArrangedSubview(dateTextField)
        
        placeStackView.addArrangedSubview(subPlaceLabel)
        placeStackView.addArrangedSubview(placeTextField)
        
        
        descriptionStackView.addArrangedSubview(subDesciptionLabel)
        descriptionStackView.addArrangedSubview(descriptionTextView)
        descriptionStackView.addArrangedSubview(descriptionLengthLabel)
        
        
        participantView.adds([subParticipantLabel, participantTextField, participantLabel])
        
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(mentLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(mentLabel.snp.bottom).offset(16)
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(contentScrollView.snp.width)
        }
        
        
        entireStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-70)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        
        titleStackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(entireStackView)
            $0.height.equalTo(120)
        }
        
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        
        titleTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleStackView)
            $0.height.equalTo(56)
        }
        
        titleLengthLabel.snp.makeConstraints {
            $0.trailing.equalTo(titleStackView)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        
        //날짜 stackView
        dateStackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(entireStackView)
            $0.height.equalTo(87)
        }
        
        subDateLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(dateStackView)
        }
        
        dateTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(dateStackView)
            $0.height.equalTo(56)
        }
        
        //장소 stackView
        placeStackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(entireStackView)
            $0.height.equalTo(87)
        }
        
        subPlaceLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeStackView)
        }
        
        placeTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeStackView)
            $0.height.equalTo(56)
        }
        
        //참여인원 stackView
        participantView.snp.makeConstraints{
            $0.leading.trailing.equalTo(entireStackView)
            $0.height.equalTo(87)
        }
        
        subParticipantLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(participantView)
        }
        
        participantTextField.snp.makeConstraints {
            $0.leading.equalTo(participantView)
            $0.top.equalTo(subParticipantLabel.snp.bottom).offset(8)
            $0.width.equalTo(80)
            $0.height.equalTo(56)
        }
        
        participantLabel.snp.makeConstraints {
            $0.centerY.equalTo(participantTextField.snp.centerY)
            $0.leading.equalTo(participantTextField.snp.trailing).offset(8)
        }
        
        //설명 stackView
        descriptionStackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(entireStackView)
            $0.height.equalTo(214)
            
        }
        
        subDesciptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        
        descriptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        descriptionLengthLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
    }
    
    private func bind() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(isTapped))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        contentScrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        //키보드 높이 설정
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
        
        
        //닫기 버튼 클릭 시 이벤트
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        //텍스트 필드 이벤트
        //dateTextField 키보드 내리는 이벤트
        dateTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.dateTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        dateTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.openDateView()
            }).disposed(by: disposeBag)
        
        
        //titleTextField 포커스 시 테두리 적용
        titleTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.titleTextField.becomeFirstResponder()
                self.titleTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.titleTextField.layer.cornerRadius = 20
                self.titleTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
                
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        //titleTextField 포커스 잃을 때 테두리 삭제 처리
        titleTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.titleTextField.layer.borderWidth = 0.0
                self.titleTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        
        //placeTextField 포커스 시 테두리 적용
        placeTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.placeTextField.becomeFirstResponder()
                self.placeTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.placeTextField.layer.cornerRadius = 20
                self.placeTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
                
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        //placeTextField 포커스 잃을 때 테두리 삭제 처리
        placeTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.placeTextField.layer.borderWidth = 0.0
                self.placeTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        //participantTextField 포커스 시 테두리 적용
        participantTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.participantTextField.becomeFirstResponder()
                self.participantTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.participantTextField.layer.cornerRadius = 20
                self.participantTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
                
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        //participantTextField 포커스 잃을 때 테두리 삭제 처리
        participantTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.participantTextField.layer.borderWidth = 0.0
                self.participantTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        
        titleTextField.rx.text
            .do{ [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0  {
                    self.nextButton.backgroundColor = .yellow200
                    self.nextButton.isEnabled = true
                    if text.count <= 30 {
                        let str =  "\(text.count)/30"
                        self.titleLengthLabel.text = str
                        let attributedString = NSMutableAttributedString(string: self.titleLengthLabel.text!)
                        let firstIndex:String.Index = str.firstIndex(of: "/")!
                        let substr = str[...firstIndex]
                        attributedString.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (self.titleLengthLabel.text! as NSString).range(of: String(substr)))
                        self.titleLengthLabel.attributedText = attributedString
                    }else{
                        let index = text.index(text.startIndex, offsetBy: 30)
                        self.titleTextField.text = String(text[..<index])
                    }
                } else {
                    self.titleLengthLabel.text = "0/30"
                    self.nextButton.backgroundColor = .grayScale500
                    self.nextButton.isEnabled = false
                }
            }
            .subscribe(onNext:  { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        
        placeTextField.rx.text
            .do{ [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0  {
                    self.nextButton.backgroundColor = .yellow200
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.backgroundColor = .grayScale500
                    self.nextButton.isEnabled = false
                }
            }
            .subscribe(onNext:  { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        
        participantTextField.rx.text
            .do{ [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0  {
                    self.nextButton.backgroundColor = .yellow200
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.backgroundColor = .grayScale500
                    self.nextButton.isEnabled = false
                }
            }
            .subscribe(onNext:  { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        
        //시간 선택 팝업 버튼 이벤트
        resetBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dateTextField.text = "상관없음"
                self?.popupView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.popupView.removeFromSuperview()
                self?.placeTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        
        descriptionTextView.rx.didBeginEditing.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.descriptionTextView.textColor = .yellow200
            if self.descriptionTextView.text == self.textViewPlaceHolder {
                self.descriptionTextView.text = nil
            }
        }, onCompleted: {
        })
        
        descriptionTextView.rx.didEndEditing.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.descriptionTextView.text == ""{
                self.descriptionTextView.text = self.textViewPlaceHolder
                self.descriptionTextView.textColor = .grayScale500
            }
        }, onCompleted: {
        })
        
        
        
        descriptionTextView.rx.text
            .do{ [weak self] text in
                guard let self = self,
                      let text = text
                else { return }
                if text.count > 0 && text != self.textViewPlaceHolder {
                    self.nextButton.backgroundColor = .yellow200
                    self.nextButton.isEnabled = true
                    if text.count <= 30 {
                        let str =  "\(text.count)/30"
                        self.descriptionLengthLabel.text = str
                        let attributedString = NSMutableAttributedString(string: self.descriptionLengthLabel.text!)
                        let firstIndex:String.Index = str.firstIndex(of: "/")!
                        let substr = str[...firstIndex]
                        attributedString.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (self.descriptionLengthLabel.text! as NSString).range(of: String(substr)))
                        self.descriptionLengthLabel.attributedText = attributedString
                    }else{
                        let index = text.index(text.startIndex, offsetBy: 30)
                        self.descriptionTextView.text = String(text[..<index])
                    }
                } else {
                    self.descriptionLengthLabel.text = "0/30"
                    self.nextButton.backgroundColor = .grayScale500
                    self.nextButton.isEnabled = false
                }
            }
            .subscribe(onNext:  { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    @objc private func isTapped(){
        self.view.endEditing(true)
        
        if self.view.subviews.contains(self.popupView){
            self.popupView.removeFromSuperview()
        }
        
        self.nextButton.layer.cornerRadius = 20
        self.nextButton.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    @objc private func openDateView(){
        dateTextField.layer.borderColor = UIColor.grayScale400.cgColor
        dateTextField.layer.cornerRadius = 20
        dateTextField.layer.borderWidth = 2.0
        
        stackView1.addArrangedSubview(resetBtn)
        stackView1.addArrangedSubview(confirmBtn)
        
        popupView.adds([popUpLabel, joinDatePicker, stackView1])
        view.add(popupView)
        
        popupView.snp.makeConstraints{
            $0.leading.equalTo(view.snp.leading).offset(0)
            $0.trailing.equalTo(view.snp.trailing).offset(0)
            $0.bottom.equalTo(view.snp.bottom).offset(0)
            $0.height.equalTo(400)
        }
        
        popUpLabel.snp.makeConstraints {
            $0.leading.equalTo(popupView.snp.leading).offset(24)
            $0.top.equalTo(popupView.snp.top).offset(32)
        }
        
        joinDatePicker.snp.makeConstraints {
            $0.top.equalTo(popUpLabel).offset(24)
            $0.leading.equalTo(popUpLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(181)
        }
        
        
        stackView1.snp.makeConstraints{
            $0.top.equalTo(joinDatePicker.snp.bottom).offset(32)
            $0.leading.equalTo(popupView.snp.leading).offset(24)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-24)
            $0.height.equalTo(56)
        }
        
    }
    
    @objc private func changed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: joinDatePicker.date)
        dateTextField.text = date
    }
    
    
}


