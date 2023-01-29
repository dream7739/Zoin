//
//  AlarmListVC.swift
//  Join
//
//  Created by 홍정민 on 2023/01/15.
//


import UIKit
import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import Moya
import Kingfisher


class AlarmListVC: BaseViewController {
    private let alarmProvider = MoyaProvider<AlarmServices>()

    var alarmList:[Alarm] = []
    var popupViewTopConstraint: Constraint? = nil

//    var isAvailable = false
//    var hasNext = false
    
    var alarmTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(AlarmListTableViewCell.self, forCellReuseIdentifier: AlarmListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarHidden(isHidden: true)
        setNavigationBar(isHidden: false)
        setNavigationName(title: "알림")
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alarmList = []
        getAlarmList()
    }
    
}

extension AlarmListVC {
    private func setLayout() {
        self.view.backgroundColor = .grayScale900
        self.alarmTableView.backgroundColor = .grayScale900
        
        view.add(alarmTableView)
        
        alarmTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        alarmTableView.rowHeight = UITableView.automaticDimension //자동 높이 조절
        alarmTableView.estimatedRowHeight = 500 //예상값
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
    }
    
    private func bind() {

    }
    
    
    func getAlarmList() {
        alarmProvider.rx.request(.list)
            .filterSuccessfulStatusCodes()
            .subscribe { result in
                switch result {
                case .success(let response):
                    guard let value = try? JSONDecoder().decode(AlarmListResponse.self, from: response.data) else {return}
                    self.alarmList += value.data
                    self.alarmTableView.reloadData()
                case .error(let error):
                    print("failure: \(error)")
                }
            }.disposed(by: disposeBag)
    }
}


extension AlarmListVC: UITableViewDelegate, UITableViewDataSource {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if self.joinTableView.contentOffset.y > joinTableView.contentSize.height-joinTableView.bounds.size.height {
//            if hasNext && isAvailable {
//                isAvailable = false
//                let cursor = mainList[mainList.count-1].id
//                getMainList(cursor: cursor)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let joinVC = JoinVC()
//        let item = self.mainList[indexPath.row]
//        let joinType = item.isMyRendezvous
//
//        joinVC.item = item
//        joinVC.joinType = joinType
//        joinVC.delegate = self
//
//        joinVC.modalPresentationStyle = .overFullScreen
//        self.present(joinVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifier, for: indexPath) as? AlarmListTableViewCell else { return UITableViewCell() }
        
        let item = alarmList[indexPath.row]
        let message = item.message
        let notiType = item.notiType
        
        //알람 구분 이미지
        if notiType == "RENDEZVOUS" {
            cell.alarmImageView.image = UIImage(named: "icon_alarm_rendezvous")
        }else if notiType == "FRIEND_REQ" {
            cell.alarmImageView.image = UIImage(named: "icon_alarm_friend")
        }
        
        //알람 메시지
        cell.alarmMessageLabel.text = message
//        cell.nameLabel.text = item.creator.userName
//        cell.idLabel.text = "@\(item.creator.serviceId)"
//        cell.countLabel.text = "\(item.participants?.count ?? 0)/\(item.requiredParticipantsCount)"
//        cell.titleLabel.text = item.title
//
//        let url = URL(string: item.creator.profileImgUrl)
//
//        let processor = (ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50)) |> RoundCornerImageProcessor(cornerRadius: 15))
//        cell.profileImg.kf.indicatorType = .activity
//
//        cell.profileImg.kf.setImage(
//          with: url,
//          placeholder: nil,
//          options: [
//            .transition(.fade(1.0)),
//            .forceTransition,
//            .processor(processor)
//          ],
//          completionHandler: nil
//        )
//
//        let dateStr = item.appointmentTime
//        let convertStr = dateStr.dateTypeChange(dateStr: dateStr)
//
//        //오늘 강조 처리
//        let attributedStr = NSMutableAttributedString(string: convertStr)
//        attributedStr.addAttribute(.font, value: UIFont.minsans(size: 14, family: .Bold)!, range: (convertStr as NSString).range(of: "오늘"))
//        attributedStr.addAttribute(.foregroundColor, value: UIColor.yellow200, range: (convertStr as NSString).range(of: "오늘"))
//
//        cell.dateLabel.attributedText = attributedStr
//        cell.placeLabel.text = item.location
        
        
        return cell
    }
    
}


