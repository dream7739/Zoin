//
//  FriendsSearchVC.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift

class FriendsSearchVC: BaseViewController {

    private let serachTextField = UITextField().then {
        $0.placeholder = "아이디를 입력하세요."
        $0.setPlaceHolderColor(.grayScale600)
        $0.tintColor = .yellow200
        $0.textColor = .yellow200
        $0.font = .minsans(size: 16, family: .Medium)
        $0.backgroundColor = .grayScale800
        $0.layer.cornerRadius = 20
        $0.addLeftPadding()
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .grayScale900
        
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
