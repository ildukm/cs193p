//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Charlie Kim on 2020/09/20.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    static let palette = "😀☺️🥰😜😏"
    
    /* will not work due to a known bug @Published var emojiArt: EmojiArt = EmojiArt() {
        didSet {
            print("json \(emojiArt.json?.utf8 ?? "nil")")
        }
     }
     */
    private var emojiArt: EmojiArt {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("json \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }
    
    private static let untitled = "Untitled"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ text: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(text, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if self.emojiArt.backgroundURL?.imageURL == url {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(self.x), y: CGFloat(self.y)) }
}
