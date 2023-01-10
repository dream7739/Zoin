//
//  MakeVC.swift
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

class MakeVC: BaseViewController {
    private var clickCnt: Int! = 0
    var appointmentTime = ""
    
    private let mentLabel = UILabel().then {
        $0.text = "번개 제목을\n자유롭게 입력해 주세요."
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
        $0.numberOfLines = 0
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
        $0.keyboardType = .numberPad
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
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = NSTimeZone.local
        $0.minimumDate = Date()
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dateStackView.removeFromSuperview()
        placeStackView.removeFromSuperview()
        participantView.removeFromSuperview()
        clickCnt = 0
    }
}

extension MakeVC {
    
    private func setLayout() {
        setTabBarHidden(isHidden: true)
        setNavigationBar(isHidden: false)
        setNavigationName(title: "번개 만들기")
        
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        
        view.adds([mentLabel, entireStackView, nextButton])
        
        entireStackView.addArrangedSubview(titleStackView)
        
        titleStackView.addArrangedSubview(subTitleLabel)
        titleStackView.addArrangedSubview(titleTextField)
        titleStackView.addArrangedSubview(titleLengthLabel)
        
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(72)
        }
        
        entireStackView.snp.makeConstraints {
            $0.top.equalTo(mentLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(mentLabel)
            $0.height.greaterThanOrEqualTo(87)
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
        
    }
    
    private func bind() {
        
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
        
        
        //다음 버튼 탭 액션
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.addInput()
                
            })
            .disposed(by: disposeBag)
        
        
        //텍스트 필드 이벤트
        //dateTextField 키보드 내리는 이벤트
        dateTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.dateTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        //titleTextField 포커스 시 테두리 적용
        titleTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.titleTextField.becomeFirstResponder()
                self.mentLabel.text = "번개 제목을\n자유롭게 입력해 주세요."
                self.titleTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.titleTextField.layer.cornerRadius = 20
                self.titleTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
                if self.clickCnt == 3 {
                    self.mentLabel.snp.updateConstraints{
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
                    }
                }
            }).disposed(by: disposeBag)
        
        
        //titleTextField 포커스 잃을 때 테두리 삭제 처리
        titleTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.titleTextField.layer.borderWidth = 0.0
                self.titleTextField.resignFirstResponder()
                if self.clickCnt == 3 {
                    self.mentLabel.snp.updateConstraints{
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
                    }
                }
            }).disposed(by: disposeBag)
        
        
        //titleTextField 터치 시 팝업뷰가 있으면 삭제
        titleTextField.rx.controlEvent([.touchDown])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        
        //placeTextField 포커스 시 테두리 적용
        placeTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.placeTextField.becomeFirstResponder()
                self.mentLabel.text = "어디로 모이면 될까요?"
                self.placeTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.placeTextField.layer.cornerRadius = 20
                self.placeTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
            }).disposed(by: disposeBag)
        
        
        //placeTextField 포커스 잃을 때 테두리 삭제 처리
        placeTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.placeTextField.layer.borderWidth = 0.0
                self.placeTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        //placeTextField 터치 시 팝업뷰가 있으면 삭제
        placeTextField.rx.controlEvent([.touchDown])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        //participantTextField 포커스 시 테두리 적용
        participantTextField.rx.controlEvent([.editingDidBegin])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.participantTextField.becomeFirstResponder()
                self.mentLabel.text = "함께할 인원을 정해주세요."
                self.participantTextField.layer.borderColor = UIColor.grayScale400.cgColor
                self.participantTextField.layer.cornerRadius = 20
                self.participantTextField.layer.borderWidth = 2.0
                self.dateTextField.layer.borderWidth = 0.0
            }).disposed(by: disposeBag)
        
        
        //participantTextField 포커스 잃을 때 테두리 삭제 처리
        participantTextField.rx.controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.participantTextField.layer.borderWidth = 0.0
                self.participantTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        
        //participantTextField 터치 시 팝업뷰가 있으면 삭제 & 멘트 변경
        participantTextField.rx.controlEvent([.touchDown])
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                if self.view.subviews.contains(self.popupView){
                    self.popupView.removeFromSuperview()
                }
                
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
                    if text == "0" {
                        self.participantTextField.text = ""
                    }else{
                        self.nextButton.backgroundColor = .yellow200
                        self.nextButton.isEnabled = true
                    }
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
        
        dateTextField.addTarget(self, action: #selector(openDateView), for: .touchDown)
        
    }
    
    
    
    @objc private func openDateView(){
        mentLabel.text = "언제 만나는게 좋을까요?"
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
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateStyle = .medium
        displayDateFormatter.timeStyle = .medium
        displayDateFormatter.locale = Locale(identifier: "ko-KR")
        displayDateFormatter.dateFormat = "yyyy. M. d. EEEE a h:mm" // 2020.08.13 오후 4시 30분
        let date = displayDateFormatter.string(from: joinDatePicker.date)
        dateTextField.text = date
        
        //서버 전송 타입
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00"
        self.appointmentTime = dateFormatter.string(from: joinDatePicker.date)
    }
    
    
    private func addInput() {
        clickCnt += 1
        if clickCnt < 4 {
            switch clickCnt {
            case 1:
                entireStackView.insertArrangedSubview(dateStackView, at: 0)
                
                dateStackView.addArrangedSubview(subDateLabel)
                dateStackView.addArrangedSubview(dateTextField)
                
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
                
                titleTextField.resignFirstResponder()
                openDateView()
                
            case 2:
                entireStackView.insertArrangedSubview(placeStackView, at: 0)
                placeStackView.addArrangedSubview(subPlaceLabel)
                placeStackView.addArrangedSubview(placeTextField)
                
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
                
                placeTextField.becomeFirstResponder()
                
            case 3:
                entireStackView.insertArrangedSubview(participantView, at: 0)
                participantView.adds([subParticipantLabel, participantTextField, participantLabel])
                
                
                
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
                participantTextField.becomeFirstResponder()
                
            default:
                return
            }
        }else{
            let makeDetailVC = MakeDetailVC()
            makeDetailVC.makeTitle = self.titleTextField.text!
            makeDetailVC.appointmentTime = self.appointmentTime
            makeDetailVC.location = self.placeTextField.text!
            makeDetailVC.requiredParticipantsCount = Int(self.participantTextField.text!)!
  
            
            self.navigationController?.pushViewController(makeDetailVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
}
