//
//  Pump.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/19.
//  Copyright © 2018年 sy. All rights reserved.
//

import Foundation

protocol Pump {
    func create(_ inputs: Inputs) -> Outputs
}
