//
//  Polynomial.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import Foundation

struct Polynomial {
    var coefficients: [Double]
    
    internal enum State {
        case graph1
        case graph2
    }
    
    static let graph1: Polynomial = Polynomial(coefficients: [41, 68, 21])
    static let graph2: Polynomial = Polynomial(coefficients: [2, -1, -9, 2])
    
    static var state: State = .graph1
    
    static var shared = graph1
    
    static func nextShared() {
        if state == .graph1 {
            shared = graph2
            state = .graph2
        } else {
            shared = graph1
            state = .graph1
        }
    }
}
