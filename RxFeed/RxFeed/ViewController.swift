//
//  ViewController.swift
//  RxFeed
//
//  Created by sy on 2017/9/28.
//  Copyright © 2017年 sy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFeedback

//system<State, Event>(
//    initialState: State,
//    reduce: @escaping (State, Event) -> State,
//    scheduler: ImmediateSchedulerType,
//    scheduledFeedback: [FeedbackLoop<State, Event>]
//)
class ViewController: UIViewController {

    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typealias State = Int
        enum Event {
            case increment
            case decrement
        }
        
        Observable.system(
            initialState: 0,
            reduce: { (state, event) -> State in
                switch event {
                case .increment:
                    return state + 1
                case .decrement:
                    return state - 1
                }
            },
            scheduler: MainScheduler.instance,
            scheduledFeedback:
            UI.bind(self) { me, state -> UI.Bindings<Event> in
                let subscriptions = [
                    state.map(String.init).bind(to: me.countLabel.rx.text)
                ]
                
                let events = [
                    me.plusBtn.rx.tap.map { Event.increment },
                    me.minusBtn.rx.tap.map { Event.decrement }
                ]
                return UI.Bindings(subscriptions: subscriptions, events: events)
            }
        )
        .subscribe()
        .addDisposableTo(disposeBag)
    }
}

