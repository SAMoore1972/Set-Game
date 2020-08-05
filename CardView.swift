//
//  CardView.swift
//  Set Game
//
//  Created by Simon Moore on 30/07/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: SetGame.Card
    
    var body: some View {
        Text("\(card.contents[0])\(card.contents[1])\(card.contents[2])\(card.contents[3])")
            .cardify(card: card)
            .aspectRatio(CARD_ASPECT_RATIO, contentMode: .fit)
            .rotation3DEffect(cardAngleFor(card.status), axis: (0,1,0))
            .transition(.offset(randomOffscreenPosition()))
            .animation(.spring())
    }

    private func cardAngleFor(_ status: SetGame.Status) -> Angle
    {
        card.status == SetGame.Status.matched ?
            Angle.degrees(MATCHED_CARD_ANGLE) :
            Angle.degrees(NORMAL_CARD_ANGLE)
    }
    
    private func randomOffscreenPosition() -> CGSize {
        let angle = Double.random(in: 0..<(2 * Double.pi))
        let distance = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * CGFloat(2.0.squareRoot())
        return CGSize(width: distance * CGFloat(cos(angle)), height: distance * CGFloat(sin(angle)))
    }

    // MARK: CardView Constatnts
    
    private let CARD_ASPECT_RATIO: CGFloat = 4/5
    private let MATCHED_CARD_ANGLE: Double = 180
    private let NORMAL_CARD_ANGLE: Double = 0
}

