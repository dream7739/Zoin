//
//  TermVC.swift
//  Join
//
//  Created by 홍정민 on 2022/06/30.
//

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya


protocol ClickDelegate : NSObjectProtocol {
    func cellClick(isClicked : Bool)
    func indicatorClick(index : Int)
}


class TermVC: BaseViewController {
    var isAllTermBtnClicked = false
    var agreeCount = 0
    
    private let titleLabel = UILabel().then {
        $0.text = "쪼인 이용에 필요한\n약관에 동의해 주세요. 📝"
        $0.numberOfLines = 0
        $0.textColor = .grayScale100
        $0.font = .minsans(size: 24, family: .Bold)
    }
    
    var termTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TermTVCell.self, forCellReuseIdentifier: TermTVCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let guideButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("전체동의하고 다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
    }
    //top 26
    //간격 16
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(isHidden: false)
        setUpNavigation()
    }
}

extension TermVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        self.termTableView.backgroundColor = .grayScale900
        
        view.isOpaque = true
        view.adds([
            titleLabel,
            termTableView,
            guideButton
        ])
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
        }
        
        termTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        guideButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(56)
        }
        
        termTableView.rowHeight = UITableView.automaticDimension
        termTableView.estimatedRowHeight = 58//예상값
        termTableView.delegate = self
        termTableView.dataSource = self
    }
    
    private func setUpNavigation() {
        title = "회원가입"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
    
    private func bind() {
        
        guideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.agreeCount == 0 {
                    for cell in self.termTableView.visibleCells {
                        let cell = cell as! TermTVCell
                        cell.isClicked = true
                    }
                    self.agreeCount = 3
                }

                self.navigationController?.pushViewController(TermDetailVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension TermVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermTVCell.identifier, for: indexPath) as! TermTVCell
        cell.indexNumber = indexPath.row
        cell.clickDelegate = self
        
        return cell
    }
}


extension TermVC : ClickDelegate {
    func indicatorClick(index: Int) {
        //        let termDetailVC = storyboard?.instantiateViewController(withIdentifier: "TermDetailViewController") as! TermDetailViewController
        //        termDetailVC.index = index
        //        self.navigationController?.pushViewController(termDetailVC, animated: true)
    }
    
    func cellClick(isClicked: Bool) {
        agreeCount = isClicked ? agreeCount + 1 : agreeCount - 1
        
        print("\(agreeCount)")
        if self.agreeCount >= 2{
            self.guideButton.isEnabled = true
            self.guideButton.backgroundColor = UIColor.yellow200
        }else if self.agreeCount == 0 {
            self.guideButton.isEnabled = true
            self.guideButton.backgroundColor = UIColor.yellow200
            self.guideButton.setTitle("전체동의하고 다음", for: .normal)
        }else {
            self.guideButton.isEnabled = false
            self.guideButton.backgroundColor = UIColor.grayScale500
            self.guideButton.setTitle("동의", for: .normal)
        }
    }
    
}
