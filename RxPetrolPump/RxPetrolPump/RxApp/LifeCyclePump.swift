//
//  LifeCyclePump.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/20.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LifeCyclePump: Pump {
    var lifeCycle: LifeCycle!
    func create(_ inputs: Inputs) -> Outputs {
        let lc = LifeCycle(sNozzle1: inputs.sNozzle1, sNozzle2: inputs.sNozzle2, sNozzle3: inputs.sNozzle3)
        lifeCycle = lc
        let delivery = lc.fillActive
            .map {
                $0 == Optional(Fuel.one) ? Delivery.FAST1 :
                $0 == Optional(Fuel.two) ? Delivery.FAST2 :
                $0 == Optional(Fuel.three) ? Delivery.FAST3 :
                Delivery.OFF
            }
            .share(replay: 1)
        
        let saleQuantityLDC = lc.fillActive.map {
                $0 == Optional(Fuel.one) ? "1" :
                $0 == Optional(Fuel.two) ? "2" :
                $0 == Optional(Fuel.three) ? "3" :
                ""
        }
        .share(replay: 1)
        
        let s1 = inputs.sNozzle1
            .map { $0 == .up }
            .share(replay: 1)
        let s2 = inputs.sNozzle2.map { $0 == .up }.share(replay: 1)
        
        let s3 = inputs.sNozzle3.map { $0 == .up }.share(replay: 1)
        
        
        
        return Outputs(delivery: delivery, saleQuantityLCD: saleQuantityLDC, s1State: s1, s2State: s2, s3State: s3)
    }
    
    static func reverse(_ p: UpDown) -> UpDown {
        return .up == p ? .down : .up
    }
}

