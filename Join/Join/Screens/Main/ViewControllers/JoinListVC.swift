//
//  JoinListVC.swift
//  Join
//
//  Created by 홍정민 on 2022/04/25.
//


import UIKit
import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import Moya


class JoinListVC: BaseViewController {
    private let makeProvider = MoyaProvider<MakeServices>()

    var mainList:[MainElements] = []
    var isAvailable = false
    var hasNext = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        mainReloadView()
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
    
    private func bind() {
        
    }
    
    func mainReloadView() {
        mainList = []
        self.getMainList(cursor: nil)
    }
    
    func getMainList(cursor: Int?) {
        makeProvider.rx.request(.main(size: 30, cursor: cursor))
            .filterSuccessfulStatusCodes()
            .subscribe { result in
                switch result {
                case .success(let response):
                    guard let value = try? JSONDecoder().decode(MainResponse.self, from: response.data) else {return}
                    self.mainList += value.data.elements
                    self.hasNext = value.data.hasNext
                    self.joinTableView.reloadData()
                    if self.hasNext {
                        self.isAvailable = true
                    }
                case .error(let error):
                    print("failure: \(error)")
                }
            }.disposed(by: disposeBag)
    }
}


extension JoinListVC: FinishMainDelegate {
    func finishMainUpdate() {
        
    }
    
    func mainReloadView(index: Int){
        mainList = []
        self.getMainList(cursor: nil)
    }
}

extension JoinListVC: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.joinTableView.contentOffset.y > joinTableView.contentSize.height-joinTableView.bounds.size.height {
            if hasNext && isAvailable {
                isAvailable = false
                let cursor = mainList[mainList.count-1].id
                getMainList(cursor: cursor)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let joinVC = JoinVC()
        let item = self.mainList[indexPath.row]
        let joinType = item.isMyRendezvous
        
        joinVC.item = item
        joinVC.joinType = joinType
        joinVC.delegate = self
        
        joinVC.modalPresentationStyle = .overFullScreen
        self.present(joinVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JoinListTableViewCell.identifier, for: indexPath) as? JoinListTableViewCell else { return UITableViewCell() }
        let item = mainList[indexPath.row]
        
        cell.nameLabel.text = item.creator.userName
        cell.idLabel.text = "@\(item.creator.serviceId)"
        cell.countLabel.text = "\(item.participants.count)/\(item.requiredParticipantsCount)"
        cell.titleLabel.text = item.title
        
        let dateStr = item.appointmentTime
        let convertStr = dateStr.dateTypeChange(dateStr: dateStr)
        
        //오늘 강조 처리
        let attributedStr = NSMutableAttributedString(string: convertStr)
        attributedStr.addAttribute(.font, value: UIFont.minsans(size: 14, family: .Bold)!, range: (convertStr as NSString).range(of: "오늘"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (convertStr as NSString).range(of: "오늘"))
        
        cell.dateLabel.attributedText = attributedStr
        cell.placeLabel.text = item.location
        
        
        return cell
    }
    
}


