//
//  Rx.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/18.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    public func unwarp<T>() -> Observable<T> where E == T? {
        return filter { $0 != nil }
                .map { $0! }
    }
}
