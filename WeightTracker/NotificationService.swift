import Foundation
import UserNotifications

final class NotificationService {
    static let reminderIdentifier = "weight-reminder"

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error { print("Notification auth error: \(error)") }
        }
    }

    func scheduleDaily(at time: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.reminderIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Weight Tracker"
        content.body = "Time to log your weight!"
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: Self.reminderIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error { print("Notification schedule error: \(error)") }
        }
    }
}
