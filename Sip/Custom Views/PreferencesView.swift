import Cocoa
import UserNotifications

class PreferencesView: NSView, LoadableView {
    @IBOutlet weak var activityLevelPopup: NSPopUpButton!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        if let loadedNibView = load(fromNIBNamed: "PreferencesView") {
             loadedNibView.subviews.forEach { subview in
                  self.addSubview(subview)
             }
            populateActivityLevels()
        } else {
             print("Error: Could not load PreferencesView.xib content in init.")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func populateActivityLevels() {
        activityLevelPopup.removeAllItems()
        let activityLevels = [
            "Low",
            "Mid",
            "High",
            "Test"
        ]

        for level in activityLevels {
            activityLevelPopup.addItem(withTitle: level)
        }
        
        guard let activityLevelSelected = UserDefaults.standard.string(forKey: "activityLevel") else { return }
        print(activityLevelSelected)
        activityLevelPopup.selectItem(withTitle: activityLevelSelected)
    }
    
    @IBAction func applySelection(_ sender: Any) {
        UserDefaults.standard.set(activityLevelPopup.titleOfSelectedItem, forKey: "activityLevel")
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.scheduleNotificationBasedOnActivityLevel()
        }
        dismissPreferences(self)
    }
    
    @IBAction func dismissPreferences(_ sender: Any) {
        self.window?.performClose(self)
    }
    
    @IBAction func ResetSips(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "sipsAmount")
        dismissPreferences(self)
    }
}
