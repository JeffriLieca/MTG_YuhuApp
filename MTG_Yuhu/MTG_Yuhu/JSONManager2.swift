//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let cardlist = try? JSONDecoder().decode(Cardlist.self, from: )
//
//import Foundation
//
//// MARK: - Cardlist
//struct Cardlist: Codable {
//    let object: String
//    let totalCards: Int
//    let hasMore: Bool
//    let data: [Datum]
//
//    enum CodingKeys: String, CodingKey {
//        case object
//        case totalCards = "total_cards"
//        case hasMore = "has_more"
//        case data
//    }
//}
//
//// MARK: - Datum
//struct Datum: Codable {
//    let object: DatumObject
//    let id, oracleID: String
//    let multiverseIDS: [Int]
//    let mtgoID, arenaID, tcgplayerID: Int
//    let cardmarketID: Int?
//    let name: String
//    let lang: Lang
//    let releasedAt: String
//    let uri, scryfallURI: String
//    let layout: Layout
//    let highresImage: Bool
//    let imageStatus: ImageStatus
//    let imageUris: ImageUris
//    let manaCost: String
//    let cmc: Int
//    let typeLine: TypeLine
//    let oracleText: String
//    let colors, colorIdentity: [ColorIdentity]
//    let keywords: [String]
//    let legalities: Legalities
//    let games: [Game]
//    let reserved, foil, nonfoil: Bool
//    let finishes: [Finish]
//    let oversized, promo, reprint, variation: Bool
//    let setID: String
//    let datumSet: Set
//    let setName: SetName
//    let setType: SetType
//    let setURI, setSearchURI, scryfallSetURI, rulingsURI: String
//    let printsSearchURI: String
//    let collectorNumber: String
//    let digital: Bool
//    let rarity: Rarity
//    let flavorText: String?
//    let cardBackID, artist: String
//    let artistIDS: [String]
//    let illustrationID: String
//    let borderColor: BorderColor
//    let frame: String
//    let frameEffects: [FrameEffect]
//    let securityStamp: SecurityStamp?
//    let fullArt, textless, booster, storySpotlight: Bool
//    let promoTypes: [PromoType]
//    let edhrecRank: Int
//    let pennyRank: Int?
//    let prices: [String: String?]
//    let relatedUris: RelatedUris
//    let purchaseUris: PurchaseUris
//    let allParts: [AllPart]?
//    let preview: Preview?
//    let producedMana: [ColorIdentity]?
//
//    enum CodingKeys: String, CodingKey {
//        case object, id
//        case oracleID = "oracle_id"
//        case multiverseIDS = "multiverse_ids"
//        case mtgoID = "mtgo_id"
//        case arenaID = "arena_id"
//        case tcgplayerID = "tcgplayer_id"
//        case cardmarketID = "cardmarket_id"
//        case name, lang
//        case releasedAt = "released_at"
//        case uri
//        case scryfallURI = "scryfall_uri"
//        case layout
//        case highresImage = "highres_image"
//        case imageStatus = "image_status"
//        case imageUris = "image_uris"
//        case manaCost = "mana_cost"
//        case cmc
//        case typeLine = "type_line"
//        case oracleText = "oracle_text"
//        case colors
//        case colorIdentity = "color_identity"
//        case keywords, legalities, games, reserved, foil, nonfoil, finishes, oversized, promo, reprint, variation
//        case setID = "set_id"
//        case datumSet = "set"
//        case setName = "set_name"
//        case setType = "set_type"
//        case setURI = "set_uri"
//        case setSearchURI = "set_search_uri"
//        case scryfallSetURI = "scryfall_set_uri"
//        case rulingsURI = "rulings_uri"
//        case printsSearchURI = "prints_search_uri"
//        case collectorNumber = "collector_number"
//        case digital, rarity
//        case flavorText = "flavor_text"
//        case cardBackID = "card_back_id"
//        case artist
//        case artistIDS = "artist_ids"
//        case illustrationID = "illustration_id"
//        case borderColor = "border_color"
//        case frame
//        case frameEffects = "frame_effects"
//        case securityStamp = "security_stamp"
//        case fullArt = "full_art"
//        case textless, booster
//        case storySpotlight = "story_spotlight"
//        case promoTypes = "promo_types"
//        case edhrecRank = "edhrec_rank"
//        case pennyRank = "penny_rank"
//        case prices
//        case relatedUris = "related_uris"
//        case purchaseUris = "purchase_uris"
//        case allParts = "all_parts"
//        case preview
//        case producedMana = "produced_mana"
//    }
//}
//
//// MARK: - AllPart
//struct AllPart: Codable {
//    let object: AllPartObject
//    let id: String
//    let component: Component
//    let name, typeLine: String
//    let uri: String
//
//    enum CodingKeys: String, CodingKey {
//        case object, id, component, name
//        case typeLine = "type_line"
//        case uri
//    }
//}
//
//enum Component: String, Codable {
//    case comboPiece = "combo_piece"
//    case token = "token"
//}
//
//enum AllPartObject: String, Codable {
//    case relatedCard = "related_card"
//}
//
//enum BorderColor: String, Codable {
//    case borderless = "borderless"
//}
//
//enum ColorIdentity: String, Codable {
//    case b = "B"
//    case g = "G"
//    case r = "R"
//    case u = "U"
//    case w = "W"
//}
//
//enum Set: String, Codable {
//    case wot = "wot"
//}
//
//enum Finish: String, Codable {
//    case foil = "foil"
//    case nonfoil = "nonfoil"
//}
//
//enum FrameEffect: String, Codable {
//    case showcase = "showcase"
//}
//
//enum Game: String, Codable {
//    case arena = "arena"
//    case mtgo = "mtgo"
//    case paper = "paper"
//}
//
//enum ImageStatus: String, Codable {
//    case highresScan = "highres_scan"
//}
//
//// MARK: - ImageUris
//struct ImageUris: Codable {
//    let small, normal, large: String
//    let png: String
//    let artCrop, borderCrop: String
//
//    enum CodingKeys: String, CodingKey {
//        case small, normal, large, png
//        case artCrop = "art_crop"
//        case borderCrop = "border_crop"
//    }
//}
//
//enum Lang: String, Codable {
//    case en = "en"
//}
//
//enum Layout: String, Codable {
//    case normal = "normal"
//}
//
//// MARK: - Legalities
//struct Legalities: Codable {
//    let standard, future, historic, gladiator: Alchemy
//    let pioneer, explorer, modern, legacy: Alchemy
//    let pauper: Alchemy
//    let vintage: Vintage
//    let penny, commander, oathbreaker, brawl: Alchemy
//    let historicbrawl, alchemy, paupercommander, duel: Alchemy
//    let oldschool, premodern, predh: Alchemy
//}
//
//enum Alchemy: String, Codable {
//    case banned = "banned"
//    case legal = "legal"
//    case notLegal = "not_legal"
//}
//
//enum Vintage: String, Codable {
//    case legal = "legal"
//    case restricted = "restricted"
//}
//
//enum DatumObject: String, Codable {
//    case card = "card"
//}
//
//// MARK: - Preview
//struct Preview: Codable {
//    let source: String
//    let sourceURI: String
//    let previewedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case source
//        case sourceURI = "source_uri"
//        case previewedAt = "previewed_at"
//    }
//}
//
//enum PromoType: String, Codable {
//    case boosterfun = "boosterfun"
//}
//
//// MARK: - PurchaseUris
//struct PurchaseUris: Codable {
//    let tcgplayer, cardmarket, cardhoarder: String
//}
//
//enum Rarity: String, Codable {
//    case mythic = "mythic"
//    case rare = "rare"
//    case uncommon = "uncommon"
//}
//
//// MARK: - RelatedUris
//struct RelatedUris: Codable {
//    let gatherer: String
//    let tcgplayerInfiniteArticles, tcgplayerInfiniteDecks, edhrec: String
//
//    enum CodingKeys: String, CodingKey {
//        case gatherer
//        case tcgplayerInfiniteArticles = "tcgplayer_infinite_articles"
//        case tcgplayerInfiniteDecks = "tcgplayer_infinite_decks"
//        case edhrec
//    }
//}
//
//enum SecurityStamp: String, Codable {
//    case oval = "oval"
//}
//
//enum SetName: String, Codable {
//    case wildsOfEldraineEnchantingTales = "Wilds of Eldraine: Enchanting Tales"
//}
//
//enum SetType: String, Codable {
//    case masterpiece = "masterpiece"
//}
//
//enum TypeLine: String, Codable {
//    case enchantment = "Enchantment"
//    case enchantmentAura = "Enchantment — Aura"
//    case enchantmentAuraCurse = "Enchantment — Aura Curse"
//    case tribalEnchantmentFaerie = "Tribal Enchantment — Faerie"
//}
