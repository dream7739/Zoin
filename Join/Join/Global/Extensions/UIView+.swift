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

}
