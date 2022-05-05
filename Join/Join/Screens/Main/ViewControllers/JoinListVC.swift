//
//  JoinListVC.swift
//  Join
//
//  Created by 홍정민 on 2022/04/25.
//


import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class JoinListVC: BaseViewController {
    var joinTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
          tableView.register(JoinListTableViewCell.self, forCellReuseIdentifier: JoinListTableViewCell.identifier)
          tableView.separatorStyle = .none
          tableView.showsVerticalScrollIndicator = false
          return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarHidden(isHidden: true)
        setNavigationBar(isHidden: false)
        setNavigationName(title: "전체보기")
        setLayout()
        bind()
    }
}

extension JoinListVC {
    private func setLayout() {
        view.addSubview(joinTableView)
        joinTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        joinTableView.rowHeight = UITableView.automaticDimension //자동 높이 조절
        joinTableView.estimatedRowHeight = 350 //예상값
        joinTableView.delegate = self
        joinTableView.dataSource = self
    }

    private func bind() { }
}

extension JoinListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinListTableViewCell.identifier, for: indexPath)
        

        return cell
    }
    
    
    
    
}

