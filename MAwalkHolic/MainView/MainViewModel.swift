//
//  MainViewModel.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/12.
//

import Foundation
import RxSwift
import RxCocoa
import HealthKit

class MainViewModel{
    let bag = DisposeBag()
    let stepListLoaded = PublishRelay<[StepModel]>()
    let authorizeSuccess = PublishSubject<Bool>()
    let didEnterForeground = PublishSubject<Void>()
    let healthStore = HKHealthStore()
    let mainModel = MainModel()
    init(){
        let enter = didEnterForeground.map{true}
        
        let getStepList = Observable.merge(enter,authorizeSuccess.filter{$0 == true})
        
        getStepList.flatMap{ _ in
            return self.mainModel.getStepModel()
        }.bind(to: self.stepListLoaded)
            .disposed(by: bag)
        

        
        
    }
}
    
