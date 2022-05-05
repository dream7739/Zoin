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



class JoinMemberConfirmVC: BaseViewController {
    var popupViewTopConstraint: Constraint? = nil
    
    var popupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 32
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
    }
    
    var memberTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(JoinMemberCell.self, forCellReuseIdentifier: JoinMemberCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    var memberCountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "참여 N명"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    
    var confirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .darkGray
        $0.setTitle("확인", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
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
        let dataCnt = 8
        self.changePopupHeight(dataCnt: dataCnt)
        return dataCnt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinMemberCell.identifier, for: indexPath)
        
        return cell
    }
    
    func changePopupHeight(dataCnt: Int){
        
        if(dataCnt < 10){
            self.popupView.snp.updateConstraints{
                let newPosition = 56 * (10-dataCnt) + 64
                self.popupViewTopConstraint =  $0.top.equalToSuperview().offset(newPosition).constraint
            }
        }
    }
    
    
}
