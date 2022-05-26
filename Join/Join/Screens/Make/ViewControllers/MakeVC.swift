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
    
    private let mentLabel = UILabel().then {
        $0.text = "번개 제목을\n자유롭게 입력해 주세요."
        $0.textColor = .black
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
    }
    
    private let titleTextField = UITextField().then {
        $0.tintColor = .black
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
        $0.addLeftPadding()
    }
    
    private let titleLengthLabel = UILabel().then {
        $0.text = "0/30"
        $0.textAlignment = .right
    }
    
    //날짜
    private let subDateLabel = UILabel().then {
        $0.text = "날짜"
    }
    
    private let dateTextField = UITextField().then {
        $0.tintColor = .black
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
        $0.addLeftPadding()
    }
    
    
    //장소
    private let subPlaceLabel = UILabel().then {
        $0.text = "장소"
    }
    
    private let placeTextField = UITextField().then {
        $0.tintColor = .black
        $0.placeholder = "구체적인 만날 장소를 입력해 주세요"
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
        $0.addLeftPadding()
    }
    
    
    //참여인원
    private let subParticipantLabel = UILabel().then {
        $0.text = "참여 인원"
    }
    
    private let participantTextField = UITextField().then {
        $0.tintColor = .black
        $0.backgroundColor = .lightGray
        $0.borderStyle = .roundedRect
        $0.addLeftPadding()
    }
    
    private let participantLabel = UILabel().then {
        $0.text = "명"
        $0.textAlignment = .left
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("다음", for: .normal)
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
        dateTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarHidden(isHidden: true)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dateStackView.removeFromSuperview()
        placeStackView.removeFromSuperview()
        participantView.removeFromSuperview()
        clickCnt = 0
    }
}

extension MakeVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField{
            return false
        }
        return true
    }
    
    @objc private func changed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: joinDatePicker.date)
        dateTextField.text = date
    }
    
    private func setLayout() {
        setTabBarHidden(isHidden: true)
        setNavigationBar(isHidden: false)
        setNavigationName(title: "번개작성")
        
        
        view.adds([mentLabel,
                   entireStackView,
                   nextButton
                  ])
        
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
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.addInput()
                
            })
            .disposed(by: disposeBag)
        
        
        //시간 선택 팝업 버튼 이벤트
        resetBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setupAppearance()
                self?.dateTextField.text = "상관없음"
                self?.datePopupView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setupAppearance()
                self?.datePopupView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        dateTextField.addTarget(self, action: #selector(openDateView), for: .touchDown)
        
    }
    
    @objc private func openDateView(){
        stackView1.addArrangedSubview(resetBtn)
        stackView1.addArrangedSubview(confirmBtn)

    
        datePopupView.adds([popupView, popUpLabel, joinDatePicker, stackView1])
        view.add(datePopupView)
        setupTransParentColor()
        datePopupView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(view)
        }
        
        
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
                participantView.adds([subParticipantLabel
                                      ,participantTextField
                                      ,(participantLabel)])
                
                
                
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
                self.navigationController?.pushViewController(makeDetailVC, animated: true)
            }
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