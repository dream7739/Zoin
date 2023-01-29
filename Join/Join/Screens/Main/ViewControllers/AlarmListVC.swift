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
    var alarmList:[Alarm] = [Alarm(notificationTypeNumber: 1, notiType: "RENDEZVOUS", createdAt: "", message: "ㅇㅇㅇㅇㅇㅇㅇ", rendezvousId: 111, friendUserId: nil)]
    
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
       // getAlarmList()
    }
    
}

extension AlarmListVC: AlarmListCellDelegate {
    func selectAcceptBtn(friendUserId: Int) {
        //6번 친구 신청 받은 유저 일 시 수락을 누르면 프로필 이동 및 친구 수락이 이루어짐
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.alarmList[indexPath.row]
        let notificationType = item.notificationTypeNumber
        let rendezvousId = item.rendezvousId
        let friendUserId = item.friendUserId
        
//        1: 친구가 새로운 번개를 열었을 때
//        - 대상: 번개 작성자 친구, 이동: 번개 상세
        switch notificationType {
        case 1:
            let tabBar = self.tabBarController
            tabBar?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("detailFlag"), object: rendezvousId)
            break
        default:
            return
        }
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
        
        //알림
        return cell
    }
    
}


