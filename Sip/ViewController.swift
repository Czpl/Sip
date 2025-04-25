import Cocoa

class ViewController: NSViewController {
    
    override func viewDidAppear() {
        super.viewWillAppear()
        
        view.window?.title = "Preferences"
        view.window?.styleMask.remove(.resizable)
        view.window?.styleMask.remove(.miniaturizable)
        view.window?.center()
        
        let preferencesView = PreferencesView(frame: self.view.bounds)
        preferencesView.add(toView: self.view)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
}

