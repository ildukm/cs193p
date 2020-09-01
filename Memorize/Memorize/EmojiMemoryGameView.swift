//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Charlie, Kim on 2020/07/12.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)
            }.padding(5)
        }
            .padding()
            .foregroundColor(Color.orange)
 
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            if (self.card.isFaceUp || !self.card.isMatched) {
                ZStack {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true).padding(5).opacity(0.4)
                    Text(self.card.content)
                }
                .font(Font.system(size: min(geometry.size.width, geometry.size.height) * 0.75))
                .cardify(isFaceUp: self.card.isFaceUp)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
