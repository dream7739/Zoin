//
//  JoinMemberConfirmVC.swift
//  Join
//
//  Created by 홍정민 on 2022/05/05.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON


class JoinMemberConfirmVC: BaseViewController {
    var popupViewTopConstraint: Constraint? = nil
    var id:Int = 0
    var participantList: [MainProfileResponse] = []
    private let makeProvider = MoyaProvider<MakeServices>()
    
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale900
        $0.layer.cornerRadius = 32
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
    }
    
    var memberTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(JoinMemberCell.self, forCellReuseIdentifier: JoinMemberCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .grayScale900
        return tableView
    }()
    
    
    var memberCountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 20, family: .Bold)
        
    }
    
    
    var confirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        participants()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    
    @objc func participants() {
        makeProvider.rx.request(.participants(id: self.id))
            .filterSuccessfulStatusCodes()
            .subscribe { result in
                switch result {
                case .success(let response):
                    guard let value = try? JSONDecoder().decode(ParticipantResponse.self, from: response.data) else {return}
                    self.participantList = value.data
                    self.memberCountLabel.text = "참여 \(self.participantList.count)명"
                    self.memberTableView.reloadData()
                case .error(let error):
                    print("failure: \(error)")
                }
            }.disposed(by: disposeBag)
    }
    
}



extension JoinMemberConfirmVC {
    private func setLayout() {
        self.view.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
        
        view.add(popupView)
        
        popupView.adds([
            memberTableView,
            memberCountLabel,
            confirmBtn
            
        ])
        
        popupView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            popupViewTopConstraint = $0.top.equalToSuperview().offset(64).constraint
        }
        
        memberCountLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(24)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(memberCountLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(confirmBtn.snp.top).offset(-56)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        
        confirmBtn.snp.makeConstraints{
            $0.leading.trailing.equalTo(memberTableView)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-46)
        }
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        
        
    }
    
    private func bind(){
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension JoinMemberConfirmVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCnt = participantList.count
        self.changePopupHeight(dataCnt: dataCnt)
        return dataCnt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JoinMemberCell.identifier, for: indexPath) as? JoinMemberCell else {
            return UITableViewCell() }
        let item = participantList[indexPath.row]
        
        cell.profileImg.image = UIImage(named: "profile")
        cell.nameLabel.text = item.userName
        cell.idLabel.text = "@\(item.serviceId)"
        
        if indexPath.row == 0 {
            cell.ownerLabel.isHidden = false
        }
        
        return cell
    }
    
    func changePopupHeight(dataCnt: Int){
        if UIDevice.current.isiPhone8 {
            if dataCnt < 6 {
                self.popupView.snp.updateConstraints{
                    let newPosition = 56 * (6-dataCnt) + 64
                    self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(newPosition).constraint
                }
            }
        } else if dataCnt < 10 {
            self.popupView.snp.updateConstraints{
                let  newPosition = 56 * (10-dataCnt) + 64
                self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(newPosition).constraint
            }
        }
        
    }
    
    
}
