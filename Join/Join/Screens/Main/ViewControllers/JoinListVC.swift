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
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    var writeBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("글작성", for: .normal)
        $0.titleLabel?.font = .minsans(size: 15, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 23
        let icon = UIImage(named: "icon_write")!
        $0.setImage(icon, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
    
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
        self.view.backgroundColor = .grayScale900
        self.joinTableView.backgroundColor = .grayScale900
        
        view.adds([joinTableView, writeBtn])
        
        joinTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        writeBtn.snp.makeConstraints {
            $0.width.equalTo(113)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-44)
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

