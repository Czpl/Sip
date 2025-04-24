import Cocoa

class SipView: NSView, LoadableView {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var volumeLabel: NSTextField!
        
    @IBOutlet weak var timeLabel: NSTextField!
    
    
    var timer: Timer?

    // MARK: - Init
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "SipView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func showDateAndTimeInfo() {
        guard let volumeLabel = volumeLabel, let timeLabel = timeLabel else {
                print("Labels not connected yet.")
                return
            }
        let date = Date()
        let formatter = DateFormatter()
        let volume = 0
        volumeLabel.stringValue = "\(volume) ml"
        
        formatter.timeStyle = .medium
        timeLabel.stringValue = formatter.string(from: date)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showDateAndTimeInfo), userInfo: nil, repeats: true)
        timer?.fire()
        
        RunLoop.current.add(timer!, forMode: .common)
    }
}
