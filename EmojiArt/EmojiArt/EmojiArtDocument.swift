//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Charlie Kim on 2020/09/20.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    static let palette = "😀☺️🥰😜😏"
    
    /* will not work due to a known bug @Published var emojiArt: EmojiArt = EmojiArt() {
        didSet {
            print("json \(emojiArt.json?.utf8 ?? "nil")")
        }
     }
     */
    /*private var emojiArt: EmojiArt {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("json \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }*/
    @Published var emojiArt: EmojiArt = EmojiArt()
    
    private var autoSaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil ) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
        autoSaveCancellable = $emojiArt.sink { emojiArt in
            print("json \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ text: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(text, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    var backgroundURL: URL? {
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
        get {
            emojiArt.backgroundURL
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
    func fetchBackgroundImageData() {
        backgroundImage = nil
        /*if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if self.emojiArt.backgroundURL?.imageURL == url {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }*/
        if let url = emojiArt.backgroundURL {
            fetchImageCancellable?.cancel()
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, URLResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(self.x), y: CGFloat(self.y)) }
}
