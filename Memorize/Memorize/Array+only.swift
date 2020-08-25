//
//  Array+only.swift
//  Memorize
//
//  Created by Charlie, Kim on 2020/08/25.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
