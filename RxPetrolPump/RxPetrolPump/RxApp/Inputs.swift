//
//  Inputs.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/19.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Inputs {
    let sNozzle1: Observable<UpDown>
    let sNozzle2: Observable<UpDown>
    let sNozzle3: Observable<UpDown>
}
