//
//  ViewModelType.swift
//  Join
//
//  Created by 이윤진 on 2022/06/16.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
