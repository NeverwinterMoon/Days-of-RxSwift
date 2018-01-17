//
//  ViewController.swift
//  RxAccumulator
//
//  Created by sy on 2018/1/17.
//  Copyright © 2018年 sy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let plusDelta = plus.rx.tap.asObservable()
            .map { 1 }
        
        let minusDelta = minus.rx.tap.asObservable()
            .map { -1 }
        
        Observable.merge(plusDelta, minusDelta).scan(0) {
            return $0 + $1
        }
        .map { "\($0)" }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

