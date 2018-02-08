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
    
    let disposeBag = DisposeBag()
    var outPuts: Outputs!
    var inPuts: Inputs!
    var p1: Pump!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        let s1 = click(btn: btn1)
        let s2 = click(btn: btn2)
        let s3 = click(btn: btn3)
        inPuts = Inputs(sNozzle1: s1, sNozzle2: s2, sNozzle3: s3)
        p1 = LifeCyclePump()
        outPuts = p1.create(inPuts)
//        btn1.isSelected = true
        

        outPuts.saleQuantityLCD.debug("my request1").bind(to: label.rx.text).disposed(by: disposeBag)
        outPuts.delivery.map { $0 == .FAST1 }.bind(to: btn1.rx.isSelected).disposed(by: disposeBag)
        outPuts.delivery.map { $0 == .FAST2 }.bind(to: btn2.rx.isSelected).disposed(by: disposeBag)
        outPuts.delivery.map { $0 == .FAST3 }.bind(to: btn3.rx.isSelected).disposed(by: disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func click(btn: UIButton) -> Observable<UpDown> {
        let x = btn.rx.tap.asObservable()
            .map { [weak btn] e -> Bool? in
                guard let btn = btn else { return nil }
                let status = !btn.isSelected
                return status
            }
            .unwarp()
            .map {
                return $0 ? UpDown.up : UpDown.down
            }
            .startWith(UpDown.down)
//            .share(replay: 0)
        
//        x.map { $0 != .down}.bind(to: btn.rx.isSelected).disposed(by: disposeBag)
        return x
    }


}

