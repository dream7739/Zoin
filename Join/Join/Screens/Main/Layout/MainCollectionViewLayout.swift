//
//  MainCollectionViewLayout.swift
//  Join
//
//  Created by 홍정민 on 2022/05/09.
//

import UIKit



class MainCollectionViewLayout: UICollectionViewLayout {
    var itemSize: CGSize {
        var width = self.collectionView!.frame.width
        var height = self.collectionView!.frame.height
        
        if UIDevice.current.isiPhone8 {
            width = width * 0.65
            height = height * 0.55
        }else {
            width = width * 0.701
            height = height * 0.51
        }
      //  print("\(width):\(height)")

        return CGSize(width: width, height: height)
    }
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
        -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
        
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    
    var radius: CGFloat = 1400{
        didSet {
            invalidateLayout() //반지름이 변경되면 재연산
        }
    }
    var anglePerItem: CGFloat {
        return atan((itemSize.width+24) / radius)
    }
    
    var attributesList = [MainCollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width:CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
    }
    
    override func prepare() {
        super.prepare()
        let centerX = collectionView!.contentOffset.x + (collectionView!.frame.width / 2.0)
        let anchorPointY = ((itemSize.height) + radius) / itemSize.height
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
            -> MainCollectionViewLayoutAttributes in
            
            let attributes = MainCollectionViewLayoutAttributes(forCellWith: NSIndexPath(item: i, section: 0) as IndexPath)
            attributes.size = self.itemSize
            
            if UIDevice.current.isiPhone8 {
                attributes.center = CGPoint(x: centerX, y:self.collectionView!.frame.midY+40)
            }else {
                attributes.center = CGPoint(x: centerX, y:self.collectionView!.frame.midY+20)

            }
            
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
    }
    
    
    
    
    override class var layoutAttributesClass: AnyClass {
        return MainCollectionViewLayoutAttributes.self
    }
    
    //모든 아이템에 대한 attributes를 반환
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    //특정 아이템의 attributes를 반환
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    
    //스크롤 시 collectionView 레이아웃 무효화
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
}


class MainCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var anchorPoint = CGPoint(x:0.5, y:0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    //객체 복사
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: MainCollectionViewLayoutAttributes = super.copy(with: zone) as! MainCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}
