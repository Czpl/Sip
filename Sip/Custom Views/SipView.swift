import Cocoa

class SipView: NSView, LoadableView {

    // MARK: - IBOutlet Properties
    @IBOutlet weak var volumeLabel: NSTextField!
    fileprivate var sipsAmount: Int = UserDefaults.standard.integer(forKey: "sipsAmount")
    var timer: Timer?

    // MARK: - Init
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        if let loadedNibView = load(fromNIBNamed: "SipView") {
            loadedNibView.subviews.forEach { subview in
                 self.addSubview(subview)
            }

        } else {
            print("Error: Could not load SipView.xib content in init.")
        }
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         if let loadedNibView = load(fromNIBNamed: "SipView") {
            loadedNibView.subviews.forEach { subview in
                self.addSubview(subview)
            }
            // Handle constraints if necessary
        } else {
             print("Error: Could not load SipView.xib content in init(coder:).")
        }
    }

     override func awakeFromNib() {
            super.awakeFromNib()
            showSipInfo() // Call here to show initial values immediately
        }

    @IBAction func sipButtonClicked(_ sender: Any) {
        sipsAmount += 1
        UserDefaults.standard.set(sipsAmount, forKey: "sipsAmount")
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            print("Successfully accessed AppDelegate in PreferencesView")
            appDelegate.updateStatusBarIcon(isEmpty: false) // Now it's safer to call
        } else {
            print("Failed to access AppDelegate in PreferencesView (later)")
        }
        showSipInfo()
    }

    @objc func showSipInfo() {
        // Safely unwrap the outlets
        guard let volumeLabel = volumeLabel else {
                print("Labels still not connected after loading. Check SipView.xib File's Owner and outlet connections.")
                return
            }

        let sips = UserDefaults.standard.integer(forKey: "sipsAmount")

        volumeLabel.stringValue = "\(sips) sips"
        
        
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
}
