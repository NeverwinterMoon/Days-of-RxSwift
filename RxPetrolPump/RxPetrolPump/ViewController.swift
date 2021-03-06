//
//  ViewController.swift
//  RxPetrolPump
//
//  Created by sy on 2018/1/17.
//  Copyright © 2018年 sy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let v = BehaviorRelay<String?>(value: nil)
    
    let disposeBag = DisposeBag()
    var outPuts: Outputs!
    var inPuts: Inputs!
    var p1: Pump!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s1 = click(btn: btn1)
        let s2 = click(btn: btn2)
        let s3 = click(btn: btn3)
        inPuts = Inputs(sNozzle1: s1, sNozzle2: s2, sNozzle3: s3)
        p1 = LifeCyclePump()
        outPuts = p1.create(inPuts)
        
        outPuts.s1State
            .bind(to: btn1.rx.isSelected)
            .disposed(by: disposeBag)
        
        outPuts.s2State
            .bind(to: btn2.rx.isSelected)
            .disposed(by: disposeBag)
        
        outPuts.s3State
            .bind(to: btn3.rx.isSelected)
            .disposed(by: disposeBag)
        
        outPuts.saleQuantityLCD
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func click(btn: UIButton) -> Observable<UpDown> {
        return btn.rx.tap.asObservable().scan(UpDown.down, accumulator: { acc, element in
            if UpDown.up == acc {
                return UpDown.down
            } else {
                return UpDown.up
            }
        })
    }


}

