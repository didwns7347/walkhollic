//
//  Date +.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/07.
//

import Foundation
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월dd일 (EEEEEE)"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
//출처: https://wiwi-pe.tistory.com/30 [선생님 개발블로그가 하고싶어요.:티스토리]
