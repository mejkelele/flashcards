import Foundation
import CryptoKit

class SecurityUtils {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func generateSalt() -> String {
        return UUID().uuidString
    }
    
    static func hashPassword(password: String, salt: String) -> String {
        let input = password + salt
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
