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
    var alarmList:[Alarm] = [Alarm(notificationTypeNumber: 1, notiType: "RENDEZVOUS", createdAt: "", message: "홍정민님이 번개를 쳤어요! 확인하러 가볼까요?", rendezvousId: 111, friendUserId: nil), Alarm(notificationTypeNumber: 2, notiType: "RENDEZVOUS", createdAt: "", message: "내가 참여한 홍정민님의 번개가 마감되었어요.\n프로필의 번개 보관함(마감)에서 확인해보세요", rendezvousId: nil, friendUserId: nil), Alarm(notificationTypeNumber: 3, notiType: "RENDEZVOUS", createdAt: "", message: "축하합니다!\n참여 인원수가 모두 차서 번개가 자동 마감되었어요.", rendezvousId: nil, friendUserId: nil), Alarm(notificationTypeNumber: 4, notiType: "RENDEZVOUS", createdAt: "", message: "야호 ! 홍정민님이 내 번개에 참여하기를 눌렀어요.", rendezvousId: 111, friendUserId: nil), Alarm(notificationTypeNumber: 5, notiType: "RENDEZVOUS", createdAt: "", message: "홍정민님의 번개에 참여했어요.\n프로필의 번개 보관함에서 확인해보세요!", rendezvousId: nil, friendUserId: nil), Alarm(notificationTypeNumber: 6, notiType: "FRIEND_REQ", createdAt: "", message: "윤가영님이 나에게 친구신청을 보냈어요.", rendezvousId: nil, friendUserId: 12),Alarm(notificationTypeNumber: 6, notiType: "FRIEND_REQ", createdAt: "", message: "윤가영님이 내 친구신청을 수락했어요.", rendezvousId: nil, friendUserId: 12)
    ]
    
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
            $0.left.equalToSuperview().offset(0)
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
    
//        1: 친구가 새로운 번개를 열었을 때
//        - 대상: 번개 작성자 친구, 이동: 번개 상세
//        2: 내가 참여한 번개가 마감되었을 때
//        - 대상: 번개 참여자, 이동: 내프로필 - 참여 번개 리스트
//        3: 내가 등록한 번개 마감되었을 때
//        - 대상: 번개 작성자, 이동: 내프로필 - 마감한 번개 리스트뷰
//        4: 번개에 내 친구가 참여했을 때
//        - 대상: 번개 작성자, 이동: 메인 - 번개 상세 - 참여자 목록 모달
//        5: 친구 번개에 내가 참여했을 때
//        - 대상: 번개 참여자, 이동: 내 프로필 - 참여 번개 리스트뷰
//        6: 친구 신청 요청
//        - 대상: 신청 받은 유저, 이동: 유저 프로필 - 자동 친구 수락
//        7: 친구 신청 수락
//        - 대상: 신청한 유저, 이동: 친구 유저 프로필
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.alarmList[indexPath.row]
        let notificationType = item.notificationTypeNumber
        let userId = item.friendUserId
        
        switch notificationType {
        case 1:
            let tabBar = self.tabBarController
            tabBar?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("alarmFlag"), object: item)
            break
        case 2:
            let profileVC = ProfileVC()
            let tabBar = self.tabBarController
            let navVC = tabBar?.viewControllers![2] as! UINavigationController
            navVC.pushViewController(profileVC, animated: false)
            profileVC.notiType = "RENDEZVOUS"
            profileVC.notificationTypeNumber = 2
            tabBar?.selectedIndex = 2
            break
        case 3:
            let tabBar = self.tabBarController
            let profileVC = ProfileVC()
            let navVC = tabBar?.viewControllers![2] as! UINavigationController
            navVC.pushViewController(profileVC, animated: false)
            profileVC.notiType = "RENDEZVOUS"
            profileVC.notificationTypeNumber = 3
            tabBar?.selectedIndex = 2
            break
        case 4:
            let tabBar = self.tabBarController
            tabBar?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("alarmFlag"), object: item)
            break
        case 5:
            let tabBar = self.tabBarController
            let profileVC = ProfileVC()
            let navVC = tabBar?.viewControllers![2] as! UINavigationController
            navVC.pushViewController(profileVC, animated: false)
            profileVC.notiType = "RENDEZVOUS"
            profileVC.notificationTypeNumber = 5
            tabBar?.selectedIndex = 2
        case 6:
            let tabBar = self.tabBarController
            let profileVC = ProfileVC()
            let navVC = tabBar?.viewControllers![2] as! UINavigationController
            navVC.pushViewController(profileVC, animated: false)
            profileVC.notiType = "FRIEND_REQ"
            profileVC.notificationTypeNumber = 6
            profileVC.userId = userId
            tabBar?.selectedIndex = 2
            break
        case 7:
            let tabBar = self.tabBarController
            let profileVC = ProfileVC()
            let navVC = tabBar?.viewControllers![2] as! UINavigationController
            navVC.pushViewController(profileVC, animated: false)
            profileVC.notiType = "FRIEND_REQ"
            profileVC.notificationTypeNumber = 7
            tabBar?.selectedIndex = 2
            break
        default:
            return
        }
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


