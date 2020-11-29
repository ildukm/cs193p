//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Charlie Kim on 2020/09/20.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
//            EmojiArtDocumentView(document: EmojiArtDocument())
            contentView()
        }
    }
    
    func contentView() -> some View {
        let store = EmojiArtDocumentStore()
        store.addDocument()
        store.addDocument(named: "Hello World")
        return EmojiArtDocumentChooser()
            .environmentObject(store)
    }
}
