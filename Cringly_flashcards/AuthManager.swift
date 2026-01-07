import Foundation
import SwiftUI
import Combine

struct UserAccount: Codable {
    let email: String
    let passwordHash: String
    let salt: String
    var username: String
    var xp: Int = 0
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserAccount?
    
    private let usersKey = "RegisteredUsersDB"
    private let sessionKey = "CurrentLoggedInUser"
    
    init() { checkSession() }
    
    
    func addXP(amount: Int) {
        guard var user = currentUser else { return }
        user.xp += amount
        currentUser = user
        updateUserInDB(user)
    }
    
    private func updateUserInDB(_ updatedUser: UserAccount) {
        var users = loadUsers()
        if let index = users.firstIndex(where: { $0.email == updatedUser.email }) {
            users[index] = updatedUser
            saveUsers(users)
        }
    }
    
    func register(email: String, password: String, completion: (Bool, String) -> Void) {
        guard SecurityUtils.isValidEmail(email) else { completion(false, "Zły e-mail"); return }
        guard password.count >= 6 else { completion(false, "Hasło min 6 znaków"); return }
        
        var users = loadUsers()
        if users.contains(where: { $0.email == email }) { completion(false, "E-mail zajęty"); return }
        
        let salt = SecurityUtils.generateSalt()
        let hash = SecurityUtils.hashPassword(password: password, salt: salt)
        // Domyślnie 0 XP
        let newUser = UserAccount(email: email, passwordHash: hash, salt: salt, username: "Nowy Użytkownik", xp: 0)
        users.append(newUser)
        saveUsers(users)
        
        login(email: email, password: password) { success, _ in completion(success, "OK") }
    }
    
    func login(email: String, password: String, completion: (Bool, String) -> Void) {
        let users = loadUsers()
        guard let foundUser = users.first(where: { $0.email == email }) else { completion(false, "Brak usera"); return }
        let inputHash = SecurityUtils.hashPassword(password: password, salt: foundUser.salt)
        
        if inputHash == foundUser.passwordHash {
            currentUser = foundUser
            isAuthenticated = true
            saveSession(email: email)
            completion(true, "Zalogowano")
        } else {
            completion(false, "Błędne hasło")
        }
    }
    
    func updateUsername(newName: String) {
        guard var user = currentUser else { return }
        user.username = newName
        currentUser = user
        updateUserInDB(user)
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }
    
    private func loadUsers() -> [UserAccount] {
        if let data = UserDefaults.standard.data(forKey: usersKey),
           let decoded = try? JSONDecoder().decode([UserAccount].self, from: data) { return decoded }
        return []
    }
    
    private func saveUsers(_ users: [UserAccount]) {
        if let encoded = try? JSONEncoder().encode(users) { UserDefaults.standard.set(encoded, forKey: usersKey) }
    }
    private func saveSession(email: String) { UserDefaults.standard.set(email, forKey: sessionKey) }
    private func checkSession() {
        if let savedEmail = UserDefaults.standard.string(forKey: sessionKey) {
            let users = loadUsers()
            if let user = users.first(where: { $0.email == savedEmail }) {
                currentUser = user
                isAuthenticated = true
            }
        }
    }
}
