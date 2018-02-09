//
//  LiftCycle.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/18.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LifeCycle {
    let bag = DisposeBag()
    let sStart: Observable<Fuel>
    var fillActive: BehaviorRelay<Fuel?>
    let sEnd: Observable<End>
    
    public enum End {
        case end
    }
    
    private static func whenLifted(_ sNozzle: Observable<UpDown>, nozzleFuel: Fuel) -> Observable<Fuel> {
        return sNozzle.filter { $0 == .up }
                        .map { _ in nozzleFuel }
    }
    
    private static func whenSetDown(_ sNozzle: Observable<UpDown>, nozzleFuel: Fuel, fillActive: BehaviorRelay<Fuel?>) -> Observable<End> {
        return sNozzle.withLatestFrom(fillActive) { (u, f)  -> LifeCycle.End? in
                return (u == .down && f == Optional(nozzleFuel)) ? End.end : nil
            }
            .unwarp()
    }
    
    init(sNozzle1: Observable<UpDown>,
         sNozzle2: Observable<UpDown>,
         sNozzle3: Observable<UpDown>
         ) {
        
        let sLiftNozzle = Observable.merge(LifeCycle.whenLifted(sNozzle1, nozzleFuel: .one),
                                           LifeCycle.whenLifted(sNozzle2, nozzleFuel: .two),
                                           LifeCycle.whenLifted(sNozzle3, nozzleFuel: .three)
                                        )
        
        fillActive = BehaviorRelay(value: nil)
        
        sStart = sLiftNozzle.withLatestFrom(fillActive) { (newFuel, fillActive_) -> Fuel? in
            if nil != fillActive_ {
                return nil
            } else {
                return newFuel
            }
        }.unwarp()
        
        sEnd = Observable.merge(LifeCycle.whenSetDown(sNozzle1, nozzleFuel: .one, fillActive: fillActive),
        LifeCycle.whenSetDown(sNozzle2, nozzleFuel: .two, fillActive: fillActive),
        LifeCycle.whenSetDown(sNozzle3, nozzleFuel: .three, fillActive: fillActive)
        )
        
        let x2 = sStart.map { e -> Fuel? in e }
        let x1 = sEnd.map { e -> Fuel? in nil }
        
        Observable.merge(x1, x2).startWith(nil).subscribe(onNext: { [weak self] f in
            self?.fillActive.accept(f)
        })
        .disposed(by: bag)
        
    }
    
    
    deinit {
        print(#function)
    }
    
}































