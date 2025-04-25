import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    var statusItem: NSStatusItem?
    var sipView: SipView?
    var preferencesWindow: NSWindow?
    var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // statusItem?.button?.title = "Sip"
        let itemImage = NSImage(named: "droplet")
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        
        if let menu = menu {
            statusItem?.menu = menu
            menu.delegate = self
            
            if let preferencesItem = menu.item(withTitle: "Settings") {
                preferencesItem.target = self
                preferencesItem.action = #selector(showPreferences(_:))
            }
            
            if let aboutItem = menu.item(withTitle: "About Sip") {
                aboutItem.target = self
                aboutItem.action = #selector(showAbout(_:))
            }
        }
        if let item = firstMenuItem {
            sipView = SipView(frame: NSRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
            item.view = sipView
        }
    }
    
    @objc func showPreferences(_ sender: Any?) {
        if preferencesWindow != nil {
            preferencesWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "preferencesID") as? ViewController else { return }
        
        let window = NSWindow(contentViewController: vc)
        window.setContentSize(NSSize(width: 350, height: 130))
        window.styleMask.insert(.titled)
        window.styleMask.remove(.resizable)
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        preferencesWindow = window
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func showAbout(_ sender: Any?) {
        NSApp.orderFrontStandardAboutPanel(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func updateStatusBarIcon(isEmpty: Bool) {
        let iconName = isEmpty ? "dropletEmpty" : "droplet"
        if let newIcon = NSImage(named: iconName) {
            newIcon.isTemplate = true
            self.statusItem?.button?.image = newIcon
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("scheduling notification on init")
        self.scheduleNotificationBasedOnActivityLevel()
        print("level set" + (UserDefaults.standard.string(forKey: "activityLevel") ?? "activity level not set"))
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Notifications are authorized.")
            } else {
                print("Notifications are NOT authorized.")
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.updateStatusBarIcon(isEmpty: true)
        completionHandler([.banner, .sound])
    }
    
    func scheduleNotificationBasedOnActivityLevel() {
        guard let activityLevel = UserDefaults.standard.string(forKey: "activityLevel") else { return }
        
        var timeInterval: TimeInterval = 0

        switch activityLevel {
        case "Low":
            timeInterval = 10800 // 3 hours
        case "Mid":
            timeInterval = 6200 // 2 hours
        case "High":
            timeInterval = 3600 // 1 hour
        case "Test":
            timeInterval = 60 // 1 minute
        default:
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        // Request permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleNotification(timeInterval: timeInterval)
            } else {
                print("Permission denied for notifications.")
            }
        }
    }

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
    
    @objc func fireTimer() {
            self.updateStatusBarIcon(isEmpty: true)
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        sipView?.showSipInfo()
    }
}
