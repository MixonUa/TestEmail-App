//
//  String + Extensions.swift
//  TestEmailApp
//
//  Created by Михаил Фролов on 30.05.2022.
//

import Foundation

extension String {
    
    func isValid() -> Bool {
        let format = "SELF MATCHES %@"
        let regEX = "[a-zA-Z0-9._]+@[a-zA-Z]+\\.[a-zA-Z]{2,}" // "\\." - выражение что б воспринять точку; {2,} - не меьше двух символов
        
        return NSPredicate(format: format, regEX).evaluate(with: self)
    }
}
