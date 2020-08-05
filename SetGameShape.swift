//
//  SetGameShape.swift
//  Set Game
//
//  Created by Simon Moore on 03/08/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

struct SetGameShape: Shape {
    let shapeStyle: Int
    
    func path(in rect: CGRect) -> Path {
        path(for: shapeStyle, in: rect)
    }
    
    private func path(for shapeStyle: Int, in rect: CGRect) -> Path! {
        switch shapeStyle {
        case 0:
            return Diamond().path(in: rect)
        case 1:
            return Squiggle().path(in: rect)
        case 2:
            return Oval().path(in: rect)
        default:
            return nil
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: 0, y: rect.midY))
        return p
    }
}

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.maxY))
        p.addLine(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: 0))
        p.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return p
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        RoundedRectangle(cornerRadius: 20).path(in: rect).path(in: rect)
    }
}
