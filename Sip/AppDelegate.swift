import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    var statusItem: NSStatusItem?
    var sipView: SipView?
    var preferencesWindow: NSWindow?
    
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
            sipView = SipView(frame: NSRect(x: 0.0, y: 0.0, width: 250.0, height: 170.0))
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
        
        // Instantiate PreferencesView and pass the AppDelegate
        let preferencesView = PreferencesView(frame: vc.view.bounds)
        preferencesView.add(toView: vc.view)
        vc.view.addSubview(preferencesView) // Ensure it's added to the view hierarchy
        
        let window = NSWindow(contentViewController: vc)
        window.title = "Preferences"
        window.setContentSize(NSSize(width: 400, height: 300))
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
        print("changing the icon")
        let iconName = isEmpty ? "dropletEmpty" : "droplet"
        if let newIcon = NSImage(named: iconName) {
            newIcon.isTemplate = true
            self.statusItem?.button?.image = newIcon
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("applicationDidFinishLaunching CALLED")
        
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
        // Insert code here to tear down your application
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent called for: \(notification.request.identifier)")
        // Request a banner and sound when the app is in the foreground
        completionHandler([.banner, .sound])
        self.updateStatusBarIcon(isEmpty: true)
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        sipView?.showSipInfo()
    }
    
}
