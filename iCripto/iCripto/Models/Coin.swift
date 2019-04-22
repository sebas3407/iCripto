import Foundation

struct Coin : Codable {
    let id, name, symbol, rank: String
    let priceUsd, priceBtc, the24HVolumeUsd, marketCapUsd: String
    let availableSupply, totalSupply : String
    let maxSupply : String = " "
    let percentChange1H: String
    let percentChange24H, percentChange7D, lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case the24HVolumeUsd = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
}
