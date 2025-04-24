import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    var statusItem: NSStatusItem?
    var sipView: SipView?

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
        }
        if let item = firstMenuItem {
            var topLevelObjects: NSArray? = nil
            if Bundle.main.loadNibNamed("SipView", owner: nil, topLevelObjects: &topLevelObjects),
               let views = topLevelObjects as? [Any],
               let loadedView = views.first(where: { $0 is SipView }) as? SipView {
                sipView = loadedView
                item.view = sipView
                print("SipView loaded from nib")
            } else {
                print("Failed to load SipView from nib")
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        sipView?.startTimer()
    }
    
}
