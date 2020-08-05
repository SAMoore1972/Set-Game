//
//  Cardify.swift
//  Set Game
//
//  Created by Simon Moore on 31/07/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    var card: SetGame.Card
    
    func body(content defaultContent: Content) -> some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
            // MARK: Debug Code
            // defaultContent
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .fill(Color.white)
                .shadow(color: .gray, radius: SHADOW_RADIUS, x: SHADOW_OFFSET, y: SHADOW_OFFSET)
            
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(cardBorderColor(for: card.status), lineWidth: STROKE_WIDTH)
            
            VStack {
                ForEach(0..<(card.contents[NUMBER] + 1)) { _ in
                    self.setGameCardShape()
                }
                .frame(width: shapeWidth(for: size), height: shapeHeight(for: size))
                .foregroundColor(cardColor())
            }
        }
        .scaleEffect(x: scaleFactor(), y: scaleFactor())
    }
    
    private func setGameCardShape() -> some View {
        SetGameShape(shapeStyle: card.contents[SHAPE])
            .setGameShading(card.contents[SHADE])
            .overlay(SetGameShape(shapeStyle: card.contents[SHAPE])
                .stroke(lineWidth: STROKE_WIDTH))
    }
    
    private func cardColor() -> Color!
    {
        switch card.contents[COLOR] {
        case RED:
            return .red
        case GREEN:
            return .green
        case PURPLE:
            return .purple
        default:
            return nil
        }
    }
    
    private func cardBorderColor(for state: SetGame.Status) -> Color
    {
        switch state {
        case SetGame.Status.selected:
            return Color.red
        case SetGame.Status.matched:
            return Color.orange
        default:
            return Color.black
        }
    }
    
    private func scaleFactor() -> CGFloat {
        (card.status == SetGame.Status.selected || card.status == SetGame.Status.matched) ?
            SELECTED_SCALE_FACTOR :
            1.0
    }

    // MARK: Cardify Constants

    private func fontSize(for size: CGSize) -> CGFloat { max(size.width, size.height) * 0.2 }
    private func shapeHeight(for size: CGSize) -> CGFloat { size.height * SHAPE_HEIGHT }
    private func shapeWidth(for size: CGSize) -> CGFloat { size.width * SHAPE_WIDTH }
    

    private let SELECTED_SCALE_FACTOR: CGFloat = 1.175
    private let STRIPED_OPACITY: Double = 0.2
    private let CORNER_RADIUS: CGFloat = 10
    private let SHADOW_OFFSET: CGFloat = 5
    private let SHADOW_RADIUS: CGFloat = 10
    private let STROKE_WIDTH: CGFloat = 2
    private let SHAPE_HEIGHT: CGFloat = 0.2
    private let SHAPE_WIDTH: CGFloat = 0.7

    private let COLOR = 0
    private let SHAPE = 1
    private let SHADE = 2
    private let NUMBER = 3
    
    private let DIAMOND = 0
    private let SQUIGGLE = 1
    private let OVAL = 2
    
    private let SOLID = 0
    private let STRIPED = 1
    private let OPEN = 2
    
    private let RED = 0
    private let GREEN = 1
    private let PURPLE = 2
}

extension View {
    func cardify(card: SetGame.Card) -> some View {
        self.modifier(Cardify(card: card))
    }
}

struct Cardify_Previews: PreviewProvider {
    static var previews: some View {
        Text("0123")
            .cardify(card: SetGame().cards[2])
            .aspectRatio(4/5, contentMode: .fit)
            .padding()
    }
}
