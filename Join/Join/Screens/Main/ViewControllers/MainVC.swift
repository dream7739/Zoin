//
//  MainVC.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class MainVC: BaseViewController {
    var currentPage: Int = 0
    var previousOffset: CGFloat = 0
    var spacing:CGFloat = 0.0
    
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
        $0.image = UIImage(named: "mainEft")
        
    }
    
    var statusLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개가 요동치는 중"
    }
    
    var mentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "현재 기다리고 있어요"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    var searchJoinListBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("전체보기 >", for: .normal)
        $0.setTitleColor(UIColor.gray, for: .normal)
    }
    
    var alarmBtn = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "alarm"), for: .normal)
    }
    
    var storageBtn = UIButton().then {
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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 32
    }
    
    var finishImg = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_finish")
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "번개를 마감했어요!"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    var subTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "마감된 번개는 프로필 보관함에서\n확인할 수 있어요."
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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarHidden(isHidden: false)
        setNavigationBar(isHidden: true)
    }
    
    
}


extension MainVC {
    private func setLayout() {
        view.adds([
            collectionView,
            mainEffectImageView,
            statusLabel,
            mentLabel,
            searchJoinListBtn,
            alarmBtn,
            storageBtn,
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.width.height.equalTo(56)
        }
        
        statusLabel.snp.makeConstraints{
            $0.leading.equalTo(mainEffectImageView.snp.leading)
            $0.top.equalTo(mainEffectImageView.snp.bottom).offset(16)
        }
        
        mentLabel.snp.makeConstraints{
            $0.leading.equalTo(mainEffectImageView.snp.leading)
            $0.top.equalTo(statusLabel.snp.bottom)
        }
        
        
        searchJoinListBtn.snp.makeConstraints{
            $0.centerY.equalTo(mentLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        alarmBtn.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(storageBtn.snp.centerY)
            $0.trailing.equalTo(storageBtn.snp.leading).offset(-24)
        }
        
        storageBtn.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
            
        }
        
        //팝업뷰 레이아웃 설정
        
        popupBackgroundView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(view)
        }
        
        finishPopupView.snp.makeConstraints {
            $0.height.equalTo(342)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
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
                let joinListVC = JoinListVC()
                self.navigationController?.pushViewController(joinListVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.popupBackgroundView.isHidden = true
                
            })
            .disposed(by: disposeBag)
    }
}

extension MainVC: MainCellDelegate {
    func selectedJoinBtn(index: Int){
        //셀 클릭 시 index에 해당하는 정보를 넘겨주면서 modal로 present함
        let joinVC = JoinVC()
        joinVC.delegate = self
        if index == 1 {
            joinVC.joinType = 2
        }
        joinVC.modalPresentationStyle = .overFullScreen
        self.present(joinVC, animated: true)
    }
}

extension MainVC: FinishMainDelegate {
    //마감 시 홈으로 나오면서 팝업 노출
    func finishMainUpdate() {
        self.popupBackgroundView.isHidden = false
    }
    
    
}



extension MainVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
}

extension MainVC: UIScrollViewDelegate {

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
        targetContentOffset.pointee = point
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
              }, completion: { _ in
                  self.collectionView.setContentOffset(point, animated: true)
              })
    }
    
    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
   
        guard let mainLayout = collectionView.collectionViewLayout as? MainCollectionViewLayout else { return .zero }
  
        let count = mainLayout.attributesList.count
        
        let itemWidth = mainLayout.itemSize.width - 37.5
        
        if  velocity.x < 0 {
            if currentPage != 0 {
                currentPage = currentPage - 1
            }
        } else if velocity.x > 0 {
            if currentPage < count - 1{
                currentPage = currentPage + 1
            }
        }

        let updatedOffset = itemWidth * CGFloat(currentPage)
        previousOffset = updatedOffset
        return CGPoint(x: updatedOffset, y: 0)
    }
   
    
}
