//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Charlie Kim on 2020/11/29.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .frame(minWidth: 300, minHeight: 500)
                        .environmentObject(document)
                    
                }
            
        }
        .fixedSize(horizontal: true, vertical: false)
        
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State private var paletteName: String = ""
    
    @State private var emojisToAdd: String = ""
    
    @Binding  var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: { isShowing = false }, label: { Text("Done")} ).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    }).padding()
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    }).padding()
                }
                Section(header: Text("Remove emoji")) {
                    ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .onTapGesture {
                                chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                            }
                    }
                }
            }
            Spacer()
        }
        .onAppear { paletteName = document.paletteNames[chosenPalette] ?? "" }
    }
}
