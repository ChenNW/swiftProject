//
//  ArrayExtensions.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import UIKit

extension Array{
    
    func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.min(n, count)])
    }
    
}
