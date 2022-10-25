//
//  StepModel.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/12.
//

import Foundation
class StepModel: NSObject {
    var step: Double = 0.0
    var date: Date = Date()
    override init() {
        super.init()
    }
    convenience init(step: Double, date: Date) {
        self.init()
        self.step = step
        self.date = date
    }
    
    var getInfo:String  {
        get {
            return "\(self.date.toString()) \(self.step) "
        }
    }
}
