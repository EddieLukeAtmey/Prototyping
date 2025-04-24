import UIKit

@propertyWrapper
struct SafeEnumDecode<T: RawRepresentable>: Codable where T.RawValue: Codable {
    var wrappedValue: T?

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(T.RawValue.self)
        wrappedValue = T(rawValue: rawValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue?.rawValue)
    }
}

struct User: Decodable {
    /*@SafeEnumDecode*/ var status: Status?

    enum Status: Int, Codable {
        case active = 1
        case inactive = 0
        case blocked = 2
    }
}

let data = #"{"status": 3}"#.data(using: .utf8)!
do {
    let u = try JSONDecoder().decode(User.self, from: data)
    print(u.status ?? "nil")
} catch {
    print(error)
    // dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "status", intValue: nil)],
    // debugDescription: "Cannot initialize Status from invalid Int value 3", underlyingError: nil))
}
