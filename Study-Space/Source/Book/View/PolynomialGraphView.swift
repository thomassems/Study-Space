//
//  PolynomialGraphView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import Foundation
import SwiftUI

struct PolynomialGraphView: View {
    @Environment(\.dismissWindow) var dismissWindow
    
    // Define the range of x values and step size
    let xRange: ClosedRange<Double> = -10...10
    let xStep: Double = 0.1
    
    // Polynomial function: calculates y for a given x
    func polynomial(_ x: Double) -> Double {
        var result: Double = 0
        for (i, coeff) in Polynomial.shared.coefficients.enumerated() {
            let degree = Polynomial.shared.coefficients.count - 1 - i
            result += coeff * pow(x, Double(degree))
        }
        return result
    }
    
    // State variable for the slider value (x position of the dot)
    @State private var xValue: Double = 0.0
    
    var polynomialResultText: String {
           // Helper function to format numbers
           func formatNumber(_ number: Double) -> String {
               let stringNumber = String(number)
               if let decimalSeparatorIndex = stringNumber.firstIndex(of: ".") {
                   let decimals = stringNumber.suffix(from: stringNumber.index(after: decimalSeparatorIndex))
                   if decimals.count > 3 {
                       // More than two decimal places
                       return String(format: "%.2f", number)
                   }
               }
               // No need to format to two decimal places
               return String(number)
           }
           
           // Filter out zero coefficients and format remaining coefficients
           let formattedCoefficients = Polynomial.shared.coefficients
               .enumerated()
               .filter { $0.element != 0 } // Filter out zero coefficients
               .map { index, coefficient in
                   let formattedCoefficient = formatNumber(coefficient)
                   return "\(formattedCoefficient)(\(formatNumber(xValue)))^\(index)"
               }
           
           // Join coefficients, but handle the case when there are no non-zero coefficients
           let coefficientsString = formattedCoefficients.isEmpty
               ? ""
               : formattedCoefficients.joined(separator: " + ")
           
           let polynomialResult = formatNumber(polynomial(xValue))
           return "f(\(formatNumber(xValue))) = \(coefficientsString) = \(polynomialResult)"
       }

    var body: some View {
        VStack {
            HStack {
                Text(polynomialResultText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding()
                Spacer()
                Button("Close") {
                    dismissWindow()
                    Polynomial.nextShared()
                }
                .padding()
            }
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let scaleX = width / (xRange.upperBound - xRange.lowerBound)
                let scaleY = height / 40.0  // Arbitrary scale for y-axis
                let centerX = width / 2
                let centerY = height / 2
                
                ZStack {
                    // Draw the polynomial curve
                    Path { path in
                        var first = true
                        for x in stride(from: xRange.lowerBound, through: xRange.upperBound, by: xStep) {
                            let y = polynomial(x)
                            
                            let plotX = centerX + x * scaleX
                            let plotY = centerY - y * scaleY  // Invert y to match screen coordinates
                            
                            if first {
                                path.move(to: CGPoint(x: plotX, y: plotY))
                                first = false
                            } else {
                                path.addLine(to: CGPoint(x: plotX, y: plotY))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    
                    // Draw x-axis
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: centerY))
                        path.addLine(to: CGPoint(x: width, y: centerY))
                    }
                    .stroke(Color.black, lineWidth: 1)
                    
                    // Draw y-axis
                    Path { path in
                        path.move(to: CGPoint(x: centerX, y: 0))
                        path.addLine(to: CGPoint(x: centerX, y: height))
                    }
                    .stroke(Color.black, lineWidth: 1)
                    
                    // Draw tick marks and labels on x-axis
                    ForEach(Int(xRange.lowerBound)...Int(xRange.upperBound), id: \.self) { i in
                        let plotX = centerX + CGFloat(i) * scaleX
                        Path { path in
                            path.move(to: CGPoint(x: plotX, y: centerY - 5))
                            path.addLine(to: CGPoint(x: plotX, y: centerY + 5))
                        }
                        .stroke(Color.black, lineWidth: 1)
                        
                        Text("\(i)")
                            .font(.footnote)
                            .position(x: plotX, y: centerY + 15)
                    }
                    
                    // Draw tick marks and labels on y-axis
                    ForEach(-20...20, id: \.self) { i in
                        let plotY = centerY - CGFloat(i) * scaleY
                        Path { path in
                            path.move(to: CGPoint(x: centerX - 5, y: plotY))
                            path.addLine(to: CGPoint(x: centerX + 5, y: plotY))
                        }
                        .stroke(Color.black, lineWidth: 1)
                        
                        if i != 0 {  // Avoid showing 0 twice
                            Text("\(i)")
                                .font(.footnote)
                                .position(x: centerX - 20, y: plotY)
                        }
                    }
                    
                    // Draw the movable dot on the graph
                    let yValue = polynomial(xValue)
                    let dotX = centerX + xValue * scaleX
                    let dotY = centerY - yValue * scaleY
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                        .position(x: dotX, y: dotY)
                    
                    // Display the y value near the dot
                    Text("(\(String(format: "%.2f", xValue)), \(String(format: "%.2f", yValue)))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .position(x: dotX, y: dotY - 20)
                }
            }
            .padding()
            
            // Slider to control the x value
            HStack {
                Text("x: \(String(format: "%.2f", xValue))")
                    .font(.headline)
                
                Slider(value: $xValue, in: xRange)
                    .padding()
            }
            .padding(.horizontal)
        }
    }
}
