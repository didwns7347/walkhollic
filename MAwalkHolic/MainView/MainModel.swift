//
//  MainModel.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/13.
//

import Foundation
import RxSwift
import RxCocoa
import HealthKit

struct MainModel{
    func getStepModel() -> Observable<[StepModel]> {
        return Observable<[StepModel]>.create { observer in
            let calender = Calendar.current
            var interval = DateComponents()
            interval.day = 1
            let healthStore = HKHealthStore()
            var anchorComponents = calender.dateComponents([.day, .month, .year], from: NSDate() as Date)
            anchorComponents.hour = 0
            let anchorDate = calender.date(from: anchorComponents)
            
            let stepQuery = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
            stepQuery.initialResultsHandler = { query, results, error in
                let endDate = NSDate()
                // 오늘로부터 30일간의 걸음수 데이터를 가져오도록 진행
                let startDate = calender.date(byAdding: .day, value: -30, to: endDate as Date, wrappingComponents: false)
                var stepList = [StepModel]()
                if let myResults = results {
                    myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                        if let quantity = statistics.sumQuantity() {
                            let date = statistics.startDate
                            let steps = quantity.doubleValue(for: HKUnit.count())
                            //self.stepDataList.append("\(date): \(steps)")
                            let model = StepModel(step: steps, date: date)
                            stepList.append(model)
                            
                        }
                    }
                    observer.onNext(stepList.reversed())
                    observer.onCompleted()
                    
                }
            }
            healthStore.execute(stepQuery)
            return Disposables.create()
        }
    }
}
