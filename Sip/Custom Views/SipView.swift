import Cocoa

class SipView: NSView, LoadableView {
    @IBOutlet weak var volumeLabel: NSTextField!
    fileprivate var sipsAmount: Int = UserDefaults.standard.integer(forKey: "sipsAmount")

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
        } else {
             print("Error: Could not load SipView.xib content in init(coder:).")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        showSipInfo()
    }

    @IBAction func sipButtonClicked(_ sender: Any) {
        sipsAmount = UserDefaults.standard.integer(forKey: "sipsAmount") + 1;
        UserDefaults.standard.set(sipsAmount, forKey: "sipsAmount")
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.updateStatusBarIcon(isEmpty: false)
        }
        showSipInfo()
    }

    @objc func showSipInfo() {
        guard let volumeLabel = volumeLabel else {
            print("Labels still not connected.")
            return
        }

        let sips = UserDefaults.standard.integer(forKey: "sipsAmount")
        volumeLabel.stringValue = "\(sips) " + (sips == 1 ? "sip" : "sips")
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
}
