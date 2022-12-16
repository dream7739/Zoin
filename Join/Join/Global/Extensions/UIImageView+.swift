//
//  UIImageView+.swift
//  Join
//
//  Created by 이윤진 on 2022/07/11.
//

import UIKit

import Kingfisher

extension UIImageView {
    /// Kingfisher 이미지 처리
    /// - Parameters:
    ///   - url: 이미지 URL
    ///   - defaultImage: 디폴트 이미지!!
    func image(url: String, defaultImage: UIImage = UIImage()) {
        kf.indicatorType = .activity
        backgroundColor = .black.withAlphaComponent(0.05)
        guard let url = URL(string: url) else {
            image = defaultImage
            return
        }
        kf.setImage(
            with: url,
            placeholder: .none,
            options: [
                .transition(ImageTransition.fade(0.5)),
                .backgroundDecode,
                .alsoPrefetchToMemory,
                .cacheMemoryOnly
            ]
        )
    }
}

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: size.width * percentage,
                                       height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: width,
                                       height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }
        func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }

}
