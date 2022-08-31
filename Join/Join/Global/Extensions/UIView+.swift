//
//  UIView+.swift
//  Join
//
//  Created by 이윤진 on 2022/04/25.
//

import UIKit
import SnapKit

extension UIView {
    
    @discardableResult
    func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
        addSubview(subview)
        closure?(subview)
        return subview
    }
    
    @discardableResult
    func adds<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
        return subviews
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
    
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    func addLineDashedStroke(radius: CGFloat, color: String){
        let borderLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        borderLayer.strokeColor = UIColor.grayScale600.cgColor
        borderLayer.lineDashPattern = [8,8]
        borderLayer.lineWidth = 1.5
        borderLayer.frame = shapeRect
                
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: shapeRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        layer.addSublayer(borderLayer)
    }
}
