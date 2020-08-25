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
            ZStack {
                if self.card.isFaceUp {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                    Text(self.card.content)
                } else if !self.card.isMatched {
                    RoundedRectangle(cornerRadius: 10).fill()
                }
                
            }
            .font(Font.system(size: min(geometry.size.width, geometry.size.height) * 0.75))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
