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
        collectionView.backgroundColor = .grayScale900
        collectionView.register(OnboardingCVCell.self, forCellWithReuseIdentifier: OnboardingCVCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let pageControl = UIPageControl().then {
        $0.frame = .init(x: 0, y: 0, width: 35, height: 15)
        $0.numberOfPages = 3
        if #available(iOS 14.0, *) {
            $0.preferredIndicatorImage = Image.Union
        } else {
            // Fallback on earlier versions
        }
        $0.currentPageIndicatorTintColor = .yellow200
        $0.pageIndicatorTintColor = .white
    }

    private let nextButton = UIButton().then {
        $0.backgroundColor = .yellow200
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.layer.cornerRadius = 16
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .minsans(size: 16, family: .Bold)
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
        setLeftBarButton()
    }
}

extension OnboardingVC {
    // MARK: - UI Settings
    func setLayout() {
        view.backgroundColor = .grayScale900
        view.isOpaque = true
        view.adds([
            collectionView,
            pageControl,
            nextButton
        ])
        pageControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom).offset(41)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
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
        navigationBar.isHidden = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
        let passButton = UIBarButtonItem(title: "건너뛰기", style: .plain, target: self, action: #selector(moveLast))
        navigationItem.rightBarButtonItem = passButton
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.minsans(size: 18, family: .Bold) ?? UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
    }
    // MARK: - Action Settings
    func setData() {
        slides = [
            OnboardingSlide(
                title: "쪼인할 사람을 초대하고",
                firstDescription: "친구를 맺으세요",
                secondDescription: "",
                image: "onboarding1"
            ),
            OnboardingSlide(
                title: "새로운 번개를 만들어보세요",
                firstDescription: "내 찐친들과 가장 쉽게",
                secondDescription: "",
                image: "onboarding2"
            ),
            OnboardingSlide(
                title: "새로운 번개를 만들어보세요",
                firstDescription: "내 찐친들과 가장 쉽게",
                secondDescription: "",
                image: "onboarding3"
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

    @objc func moveLast() {
        self.currentPage = 2
        let indexPath = IndexPath(item: self.currentPage, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        return CGSize(width: view.frame.width, height: 400)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }

}
