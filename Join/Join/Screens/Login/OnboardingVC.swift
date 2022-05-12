//
//  OnboardingVC.swift
//  Join
//
//  Created by 이윤진 on 2022/05/04.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class OnboardingVC: BaseViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(OnboardingCVCell.self, forCellWithReuseIdentifier: OnboardingCVCell.identifier)

        return collectionView
    }()

    private let pageControl = UIPageControl().then {
        $0.frame = .init(x: 0, y: 0, width: 35, height: 15)
        $0.numberOfPages = 3
        $0.currentPageIndicatorTintColor = .yellow
        $0.pageIndicatorTintColor = .lightGray
    }

    private let nextButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
    }

    private var slides: [OnboardingSlide] = []

    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("시작하기", for: .normal)
            } else {
                nextButton.setTitle("다음", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setData()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
    }
}

extension OnboardingVC {
    // MARK: - UI Settings
    func setLayout() {
        view.adds([
            collectionView,
            pageControl,
            nextButton
        ])
        pageControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(85)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom).offset(21)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        nextButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(327)
            make.height.equalTo(56)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setUpNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationBar.isHidden = true
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }
    // MARK: - Action Settings
    func setData() {
        slides = [
            OnboardingSlide(
                title: "새로운 번개를 만들어보세요",
                firstDescription: "내 찐친들과 가장 쉽게",
                secondDescription: "만나는어쩔티비저쩔티비",
                image: "3D_Bulb"
            ),
            OnboardingSlide(
                title: "새로운 번개를 만들어보세요",
                firstDescription: "내 찐친들과 가장 쉽게",
                secondDescription: "만나는어쩔티비저쩔티비",
                image: "3D_Calendar"
            ),
            OnboardingSlide(
                title: "새로운 번개를 만들어보세요",
                firstDescription: "내 찐친들과 가장 쉽게",
                secondDescription: "만나는어쩔티비저쩔티비",
                image: "3D_Chat"
            )
        ]

        pageControl.numberOfPages = slides.count
    }

    private func bind() {
        nextButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if self.currentPage == self.slides.count - 1 {
                let viewController = CautionVC()
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.currentPage += 1
                let indexPath = IndexPath(item: self.currentPage, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        })
            .disposed(by: disposeBag)
    }
}

extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVCell.identifier, for: indexPath) as! OnboardingCVCell
        cell.bind(slides[indexPath.row])
        return cell
    }
}

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }

}
