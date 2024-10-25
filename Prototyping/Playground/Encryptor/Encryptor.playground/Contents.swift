import Foundation
import CryptoSwift
import XCTest

// CryptoSwift
func encryptAES(data: String, key: String, iv: String) -> String? {
    do {
        // Convert key and iv to bytes (arrays of UInt8)
        let keyBytes = Array(key.utf8)
        let ivBytes = Array(iv.utf8) // 16 bytes IV for AES-CTR

        // Convert plaintext data to bytes
        let dataBytes = Array(data.utf8)

        // Initialize AES with CTR mode and no padding
        let aes = try AES(key: keyBytes, blockMode: CTR(iv: ivBytes), padding: .noPadding)

        // Perform encryption
        let encryptedBytes = try aes.encrypt(dataBytes)

        // Combine IV and encrypted bytes
        let finalEncryptedData = ivBytes + encryptedBytes

        // Convert to Base64 string
        let base64Encoded = Data(finalEncryptedData).base64EncodedString()

        return base64Encoded
    } catch {
        print("Encryption failed: \(error)")
        return nil
    }
}

func decryptWithIV(data: String, key: String, ivString: String) -> String? {
    do {
        // Convert the IV from string to bytes (UInt8 array)
        let ivBytes = Array(ivString.utf8)
        if ivBytes.count != 16 {
            print("IV must be 16 bytes long.")
            return nil
        }

        // Decode base64 encoded string
        guard let encryptedData = Data(base64Encoded: data) else {
            print("Failed to decode base64 encoded string.")
            return nil
        }

        // Ensure the encrypted data length is valid
        let encryptedBytes = Array(encryptedData)
        guard encryptedBytes.count > ivBytes.count else {
            print("Encrypted data is too short.")
            return nil
        }

        // Extract the actual encrypted data (excluding the IV)
        let dataBytes = Array(encryptedBytes[ivBytes.count..<encryptedBytes.count])

        // Convert the key to bytes (UInt8 array)
        let keyBytes = Array(key.utf8)

        // Initialize AES with CTR mode and no padding
        let aes = try AES(key: keyBytes, blockMode: CTR(iv: ivBytes), padding: .noPadding)

        // Perform decryption
        let decryptedBytes = try aes.decrypt(dataBytes)

        // Convert the decrypted bytes back to a string
        let decryptedString = String(bytes: decryptedBytes, encoding: .utf8)

        return decryptedString
    } catch {
        print("Decryption failed: \(error)")
        return nil
    }
}

// Test
let key = "IM6KnzFjcYch0vgqEQ2oy4fV79HQiaMu"
let iv = "kceE45RL3kWmEtTM"
let data = "121212"
let result = "a2NlRTQ1Ukwza1dtRXRUTVS15bgoOQ=="
          // "a2NlRTQ1Ukwza1dtRXRUTVS15bgoOQ=="

if let encryptedString = encryptAES(data: data, key: key, iv: iv) {
    print("Encrypted: \(encryptedString)")
    print(encryptedString == result)
    XCTAssert(encryptedString == result)

    let decrypt = decryptWithIV(data: encryptedString, key: key, ivString: iv)

    print("Decrypted: \(decrypt ?? "null")")
    print(decrypt == data)
} else {
    print("Encryption failed")
}

