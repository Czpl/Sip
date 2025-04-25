import Cocoa
import UserNotifications

class PreferencesView: NSView, LoadableView {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var activityLevelPopup: NSPopUpButton!

    // MARK: - Init
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        if let loadedNibView = load(fromNIBNamed: "PreferencesView") {
                     // Add the subviews from the loaded nib view to this PreferencesView instance
                     loadedNibView.subviews.forEach { subview in
                          self.addSubview(subview)
                     }
                    populateActivityLevels() // Moved population to awakeFromNib
                } else {
                     print("Error: Could not load PreferencesView.xib content in init.")
                }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Custom Fileprivate Methods
    
    fileprivate func populateActivityLevels() {
        // Remove default items from the popup button.
        activityLevelPopup.removeAllItems()
        let activityLevels = [
            "Low",
            "Mid",
            "High"
        ]
        // Populate all available timezone identifiers to the popup.
        // Since this is a demo app there's no need to apply any formatting.
        for level in activityLevels {
            activityLevelPopup.addItem(withTitle: level)
        }
        
        // If a timezone had been previously selected, then select it automatically.
        guard let activityLevelSelected = UserDefaults.standard.string(forKey: "activityLevel") else { return }
        activityLevelPopup.selectItem(withTitle: activityLevelSelected)
    }
    

    
    // MARK: - IBAction Methods
        
    @IBAction func applySelection(_ sender: Any) {
        UserDefaults.standard.set(activityLevelPopup.titleOfSelectedItem, forKey: "activityLevel")
        
        scheduleNotificationBasedOnActivityLevel()
        dismissPreferences(self)
    }
    
    
    @IBAction func dismissPreferences(_ sender: Any) {
        self.window?.performClose(self)
    }
    
    // Function to schedule a notification based on the selected activity level
        func scheduleNotificationBasedOnActivityLevel() {
            // Retrieve the selected activity level
            guard let activityLevel = UserDefaults.standard.string(forKey: "activityLevel") else { return }
            
            var timeInterval: TimeInterval = 0

            // Set the time interval based on the selected activity level
            switch activityLevel {
            case "Low":
                timeInterval = 600 // 10 minutes
            case "Mid":
                timeInterval = 300 // 5 minutes
            case "High":
                timeInterval = 60 // 2 minutes
            default:
                return
            }
            
           
            // Request permission to send notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    // Schedule the notification
                    self.scheduleNotification(timeInterval: timeInterval)
                } else {
                    print("Permission denied for notifications.")
                }
            }
        }

        // Function to schedule a local notification
        func scheduleNotification(timeInterval: TimeInterval) {
            let content = UNMutableNotificationContent()
            content.title = "Time to Sip!"
            content.body = "It's time for your next sip."
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            let request = UNNotificationRequest(identifier: "sipNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully.")
                }

            }
        }
        
}
