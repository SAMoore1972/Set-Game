//
//  StripePattern.swift
//  Set Game
//
//  Created by Simon Moore on 04/08/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

private struct StripePatternModifier: ViewModifier {
    var shadeType: Int
    
    func body(content: Content) -> some View {
        Group {
            if shadeType == SOLID {
                content
            } else if shadeType == STRIPED {
                ZStack {
                    content
                        .opacity(0.0)
                    StripePattern(STRIPE_WIDTH, STRIPE_GAP)
                        .mask(content)
                }
            } else if shadeType == OPEN {
                ZStack {
                    content
                        .opacity(0.0)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Stripe Modifier Constants
    private let STRIPE_WIDTH = 2
    private let STRIPE_GAP = 2
    private let SOLID = 0
    private let STRIPED = 1
    private let OPEN = 2
}

extension View {
    func setGameShading(_ type: Int) -> some View {
        self.modifier(StripePatternModifier(shadeType: type))
    }
}


private struct StripePattern: Shape {
    let width: Int
    let gapSize: Int
    
    init(_ width: Int, _ gapSize: Int) {
        self.width = width
        self.gapSize = gapSize
    }
    
    func path(in rect: CGRect) -> Path {
        let numberOfStripes = Int(rect.width) / width
        
        var p = Path()
        
        p.move(to: rect.origin)
        
        for index in 0...numberOfStripes {
            if index % gapSize == 0 {
                p.addRect(CGRect(x: CGFloat(index * width), y: 0, width: CGFloat(width), height: rect.height))
            }
        }
        
        return p
    }
}
