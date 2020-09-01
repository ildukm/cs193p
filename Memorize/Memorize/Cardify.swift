//
//  Cardify.swift
//  Memorize
//
//  Created by Charlie, Kim on 2020/09/01.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if isFaceUp {
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
            RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidht)
            content
        } else {
            RoundedRectangle(cornerRadius: cornerRadius).fill()
        }
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidht: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
