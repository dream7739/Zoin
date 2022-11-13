//
//  ReportVC.swift
//  Join
//
//  Created by 홍정민 on 2022/09/21.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON


protocol ReportDelegate : NSObjectProtocol {
    func cellClick(index : Int)
}

class ReportVC: BaseViewController {
    private let reportProvider = MoyaProvider<ReportServices>()
    var reasonId: Int = -1
    var rendezvousId: Int = 0
    var viewTranslation:CGPoint = CGPoint(x: 0, y: 0)
    let textViewPlaceHolder = "신고 사유를 입력해 주세요."
    
    var popupViewTopConstraint: Constraint? = nil
    
    let stackView1 = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 11
        $0.distribution = .fillEqually
    }
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale900
        $0.layer.cornerRadius = 40
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    var indicatorLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale600
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "이 글을 신고하시겠어요?"
        $0.numberOfLines = 0
        $0.textColor = .grayScale100
        $0.textAlignment = .center
        $0.font = .minsans(size: 20, family: .Bold)
    }
    
    var reportTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ReportCell.self, forCellReuseIdentifier: ReportCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 42
        return tableView
    }()
    
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
        $0.font = .minsans(size: 14, family: .Medium)
    }
    
    var cancelBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    var reportBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale500
        $0.setTitleColor(.grayScale300, for: .normal)
        $0.setTitle("신고하기", for: .normal)
        $0.isEnabled = false
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



extension ReportVC {
    private func setLayout() {
        view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
        
        self.reportTableView.backgroundColor = .grayScale900
        
        view.add(popupView)
        
        stackView1.addArrangedSubview(cancelBtn)
        stackView1.addArrangedSubview(reportBtn)
        
        popupView.adds([
            indicatorLabel,
            titleLabel,
            reportTableView,
            descriptionTextView,
            descriptionLengthLabel,
            stackView1
        ])
        
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
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(indicatorLabel.snp.bottom).offset(46)
        }
        
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.height.lessThanOrEqualTo(250)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(reportTableView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(154)
        }
        
        descriptionLengthLabel.snp.makeConstraints {
            $0.trailing.equalTo(descriptionTextView.snp.trailing)
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(8)
        }
        
        stackView1.snp.makeConstraints{
            $0.leading.trailing.equalTo(descriptionTextView)
            $0.bottom.equalToSuperview().offset(-48)
            $0.height.equalTo(56)
        }
        
        reportTableView.rowHeight = UITableView.automaticDimension
        reportTableView.estimatedRowHeight = 58//예상값
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
    }
    
    private func bind(){
        descriptionTextView.text = textViewPlaceHolder
        
        cancelBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        descriptionTextView.rx.didBeginEditing.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.descriptionTextView.textColor = .yellow200
            if (self.descriptionTextView.text == self.textViewPlaceHolder) {
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
                    if text.count <= 100 {
                        let str =  "\(text.count)/100"
                        self.descriptionLengthLabel.text = str
                        let attributedString = NSMutableAttributedString(string: self.descriptionLengthLabel.text!)
                        let firstIndex:String.Index = str.firstIndex(of: "/")!
                        let substr = str[...firstIndex]
                        attributedString.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (self.descriptionLengthLabel.text! as NSString).range(of: String(substr)))
                        self.descriptionLengthLabel.attributedText = attributedString
                    }else{
                        let index = text.index(text.startIndex, offsetBy: 100)
                        self.descriptionTextView.text = String(text[..<index])
                    }
                } else {
                    self.descriptionLengthLabel.text = "0/100"
                }
            }
            .subscribe(onNext:  { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        
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
            }
        default:
            break
        }
    }
    
}


extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.identifier, for: indexPath) as! ReportCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "영리목적/홍보성"
        case 1:
            cell.titleLabel.text = "욕설/인신공격"
        case 2:
            cell.titleLabel.text = "음란/선정성"
        case 3:
            cell.titleLabel.text = "같은 내용 도배"
        case 4:
            cell.titleLabel.text = "기타"
        default:
            break
        }
        
        if reasonId == indexPath.row {
            cell.isClicked = true
        }else{
            cell.isClicked = false
        }
        
        cell.indexNumber = indexPath.row
        
        cell.reportDelegate = self
        
        return cell
    }
}


extension ReportVC: ReportDelegate {
    func cellClick(index: Int) {
        
        self.reasonId = index
        self.reportTableView.reloadData()
        
        if(reasonId == -1){
            reportBtn.backgroundColor = .yellow200
            reportBtn.setTitleColor(.grayScale900, for: .normal)
            
            reportBtn.isEnabled = true
        }
        
        if(reasonId != 4){
            self.descriptionTextView.endEditing(true)
        }else if reasonId == 4 {
            self.descriptionTextView.becomeFirstResponder()
            
        }
        
    }
    
}

