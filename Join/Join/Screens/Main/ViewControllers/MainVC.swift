//
//  MainVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import SnapKit
import SwiftyJSON
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import Moya


class MainVC: BaseViewController {
    private let makeProvider = MoyaProvider<MakeServices>()
    private let networkQueue = DispatchQueue(label: "network", qos: .background, attributes: .concurrent)
    private let networkGroup = DispatchGroup()
    
    var currentPage: Int = 0
    var weather:Int = 0
    var previousOffset: CGFloat = 0
    var spacing:CGFloat = 0.0
    var imgArr = ["gradient1", "gradient2", "gradient3", "gradient4", "gradient1", "gradient2", "gradient3", "gradient4"]
    var mainList:[MainElements] = []
    var isAvailable = false
    var hasNext = false
    
    //메인 뷰
    var collectionView: UICollectionView = {
        
        let layout = MainCollectionViewLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var mainEffectImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var statusLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 16, family: .Medium)
        $0.textColor = .grayScale100
    }
    
    var mentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .minsans(size: 24, family: .Bold)
        $0.textColor = .grayScale100
    }
    
    var searchJoinListBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.grayScale400, for: .normal)
        $0.titleLabel?.font = .minsans(size: 14, family: .Medium)
        $0.contentHorizontalAlignment = .center
    }
    
    var indicatorBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "arrow_right"), for: .normal)
        $0.contentHorizontalAlignment = .center
    }
    
    var alarmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "alarm"), for: .normal)
    }
    
    var inviteBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "storage"), for: .normal)
    }
    
    
    //마감 팝업 뷰
    var popupBackgroundView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 17/255, green: 23/255, blue: 35/255, alpha: 0.6)
    }
    
    var finishPopupView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 32
    }
    
    var finishImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "finish2")
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개를 마감했어요!"
        $0.font = .minsans(size: 20, family: .Bold)
        $0.textColor = .grayScale100
        $0.textAlignment = .center
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "마감된 번개는 프로필에서 확인하세요."
        $0.numberOfLines = 0
        $0.font = .minsans(size: 16, family: .Medium)
        $0.textColor = .grayScale300
        $0.textAlignment = .center
    }
    
    var confirmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
        $0.contentHorizontalAlignment = .center
        $0.layer.cornerRadius = 20
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        bind()
        addNotiObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarHidden(isHidden: false)
        setNavigationBar(isHidden: true)
        getNetworkData()
    }
    
    
    func addNotiObserver(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openList),
                                               name: NSNotification.Name("listFlag"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openDetail),
                                               name: NSNotification.Name("detailFlag"),
                                               object: nil)
    }
    
    @objc func openList(notification : NSNotification){
        if notification.object != nil {
            pushJoinListVC()
        }
    }
    
    @objc func openDetail(notification : NSNotification){
        if let item = notification.object as? MainElements{
            let joinVC = JoinVC()
            let item = item
            
            joinVC.item = item
            joinVC.joinType = true //생성 -> 내번개
            joinVC.delegate = self
            
            joinVC.modalPresentationStyle = .overFullScreen
            self.present(joinVC, animated: true)
        }
    }
}


extension MainVC {
    private func setLayout() {
        view.backgroundColor = .grayScale900
        collectionView.backgroundColor = .grayScale900
        
        view.adds([
            collectionView,
            mainEffectImageView,
            statusLabel,
            mentLabel,
            searchJoinListBtn,
            indicatorBtn,
            alarmBtn,
            inviteBtn,
            popupBackgroundView
        ])
        
        //팝업뷰 설정
        popupBackgroundView.add(finishPopupView)
        finishPopupView.adds([
            finishImg,
            titleLabel,
            subTitleLabel,
            confirmBtn
        ])
        
        
        //메인뷰 레이아웃 설정
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "mainCell")
        
        
        mainEffectImageView.snp.makeConstraints {
            if UIDevice.current.isiPhone8 {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
                $0.width.height.equalTo(72)
            }else{
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
                $0.width.height.equalTo(72)
            }
        }
        
        statusLabel.snp.makeConstraints{
            if UIDevice.current.isiPhone8 {
                $0.leading.equalTo(mainEffectImageView.snp.leading)
                $0.top.equalTo(mainEffectImageView.snp.bottom).offset(10)
            }else {
                $0.leading.equalTo(mainEffectImageView.snp.leading)
                $0.top.equalTo(mainEffectImageView.snp.bottom).offset(16)
            }
        }
        
        mentLabel.snp.makeConstraints{
            $0.leading.equalTo(mainEffectImageView.snp.leading)
            $0.top.equalTo(statusLabel.snp.bottom)
        }
        
        
        searchJoinListBtn.snp.makeConstraints{
            $0.centerY.equalTo(indicatorBtn.snp.centerY)
            $0.trailing.equalTo(indicatorBtn.snp.leading)
        }
        
        indicatorBtn.snp.makeConstraints{
            $0.width.height.equalTo(16)
            $0.centerY.equalTo(mentLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        alarmBtn.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(inviteBtn.snp.centerY)
            $0.trailing.equalTo(inviteBtn.snp.leading).offset(-24)
        }
        
        inviteBtn.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
            
        }
        
        //팝업뷰 레이아웃 설정
        
        popupBackgroundView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(view)
        }
        
        finishPopupView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
            $0.height.equalTo(316)
        }
        
        finishImg.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalTo(finishPopupView.snp.centerX)
            $0.top.equalTo(finishPopupView.snp.top).offset(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(finishImg.snp.bottom).offset(24)
            $0.centerX.equalTo(finishImg.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        confirmBtn.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.equalTo(finishPopupView.snp.leading).offset(24)
            $0.trailing.equalTo(finishPopupView.snp.trailing).offset(-24)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(32)
        }
        
        popupBackgroundView.isHidden = true
        
    }
    
    func bind(){
        
        searchJoinListBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushJoinListVC()
            })
            .disposed(by: disposeBag)
        
        indicatorBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushJoinListVC()
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.popupBackgroundView.isHidden = true
                
            })
            .disposed(by: disposeBag)
        
        inviteBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let inviteVC = InviteVC()
                inviteVC.modalPresentationStyle = .overFullScreen
                self.present(inviteVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func pushJoinListVC(){
        let joinListVC = JoinListVC()
        self.navigationController?.pushViewController(joinListVC, animated: true)
    }
    
    func getNetworkData(){
        mainList = []
        getMainList(cursor: nil)
        getCurrentWeather()
    }
    
    
    func getMainList(cursor: Int?) {
        networkGroup.enter()
        makeProvider.rx.request(.main(size: 5, cursor: cursor))
            .filterSuccessfulStatusCodes()
            .subscribe { result in
                self.networkQueue.async(group: self.networkGroup) {
                    switch result {
                    case .success(let response):
                        guard let value = try? JSONDecoder().decode(MainResponse.self, from: response.data) else {return}
                        self.mainList += value.data.elements
                        self.hasNext = value.data.hasNext
                        
                        DispatchQueue.main.async {
                            UIView.performWithoutAnimation {
                                //스크롤 포지션 변경되지 않도록 변경함
                                self.collectionView.reloadSections(IndexSet(integer: 0))
                            }
                        }
                        
                        if self.hasNext {
                            self.isAvailable = true //isAvailable - 무한로딩 방지(1회 실행)
                        }
                    case .error(let error):
                        print("failure: \(error)")
                    }
                    self.networkGroup.leave()
                }
            }.disposed(by: disposeBag)
        
    }
    
    func getCurrentWeather() {
        networkGroup.enter()
        makeProvider.rx.request(.current)
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                self?.networkQueue.async(group: self?.networkGroup) {
                    let status = JSON(response.data)["status"]
                    let data = JSON(response.data)["data"]  //맑음: 0, 번개: 1, 흐림 2
                    if status == 200 {
                        self?.weather = data.intValue
                        
                        DispatchQueue.main.async {
                            self?.updateWeather()
                        }
                        
                    }else{
                        print("\(status)")
                    }
                }
                self?.networkGroup.leave()
            }, onError: { [weak self] _ in
                print("error occured")
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    func updateWeather(){
        switch weather {
        case 0:
            mainEffectImageView.image = UIImage(named: "sunny")
            statusLabel.text  = "번개가 요동치는 중"
            mentLabel.text = "참여하러 가볼까요?"
        case 1:
            mainEffectImageView.image = UIImage(named: "thunder")
            statusLabel.text  = "엄청난 천둥 번개"
            mentLabel.text = "지금 놓치지 마세요!"
        case 2:
            mainEffectImageView.image = UIImage(named: "fog")
            statusLabel.text  = "흐린 구름만 잔뜩"
            mentLabel.text = "번개치기로 힘을 주세요!"
        default:
            return
        }
    }
}


extension MainVC: MainCellDelegate {
    func selectedJoinBtn(index: Int){
        //셀 클릭 시 index에 해당하는 정보를 넘겨주면서 modal로 present함
        let joinVC = JoinVC()
        let item = self.mainList[index]
        let joinType = item.isMyRendezvous
        
        joinVC.item = item
        joinVC.joinType = joinType
        joinVC.atndFlag = item.whetherUserParticipateOrNot!
        joinVC.delegate = self
        
        joinVC.modalPresentationStyle = .overFullScreen
        self.present(joinVC, animated: true)
    }
}

extension MainVC: FinishMainDelegate {
    //마감 - 홈
    func finishMainUpdate() {
        print("finishToMain")
        popupBackgroundView.isHidden = false
        getNetworkData()
    }
    
    //참여 - 홈
    func mainReloadView() {
        print("joinToMain")
        getNetworkData()
        
    }
}



extension MainVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.x > collectionView.contentSize.width-collectionView.bounds.size.width {
            if hasNext && isAvailable {
                isAvailable = false
                let cursor = mainList[mainList.count-1].id
                getMainList(cursor: cursor)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        
        if indexPath.row <= mainList.count - 1 {
            let item = mainList[indexPath.row]
            cell.index = indexPath.row
            cell.nameLabel.text = item.creator.userName
            cell.idLabel.text = "@\(item.creator.serviceId)"
            cell.countLabel.text = "\(item.participants?.count ?? 0)/\(item.requiredParticipantsCount)"
            cell.titleLabel.text = item.title
            
            let dateStr = item.appointmentTime
            cell.dateLabel.text = dateStr.dateTypeChange(dateStr: dateStr)
            cell.placeLabel.text = item.location
            
            //MARK: 추후 변경 필요
            let shuffledImgArr = imgArr.shuffled()
            cell.backGroundImg.image = UIImage(named: shuffledImgArr[0])
        }
        
        
        return cell
    }
}
