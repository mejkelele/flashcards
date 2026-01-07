import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Zgoda na powiadomienia przyznana")
                self.scheduleDailyReminder()
            } else if let error = error {
                print("Błąd powiadomień: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Czas na naukę! 🧠"
        content.body = "Nie zrobiłeś jeszcze dzisiaj swoich fiszek. Zbieraj XP!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotificationForToday() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        print("Powiadomienie na dziś anulowane - brawo za naukę!")
    }
}
