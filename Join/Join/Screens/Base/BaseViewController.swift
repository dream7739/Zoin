//
//  BaseViewController.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import RxSwift
import SnapKit

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultUI()
        setNavigationItems()
        setupAppearance()
    }

}

extension BaseViewController {
    private func defaultUI() {
        view.backgroundColor = .white
    }

    private func setNavigationItems() {
        if navigationController?.children.count ?? 0 > 1 {
            let backImage = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)

            let backButton = UIBarButtonItem(image: backImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(didBack))
            navigationItem.leftBarButtonItem = backButton
        }
    }

    func setNavigationBar(isHidden: Bool) {
      navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

    @objc func didBack() {
      navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController: UINavigationBarDelegate {
  private func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .white
    appearance.shadowColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
}
