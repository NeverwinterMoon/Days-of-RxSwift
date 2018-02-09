//
//  Outputs.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/19.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Outputs {
    
    let delivery: Observable<Delivery>
//    let presetLCD: BehaviorRelay<String>?
    let saleQuantityLCD: Observable<String>
    
    let s1State: Observable<Bool>
    
    let s2State: Observable<Bool>
    
    let s3State: Observable<Bool>
}
