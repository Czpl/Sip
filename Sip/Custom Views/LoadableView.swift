import Cocoa

protocol LoadableView: AnyObject {
    func load(fromNIBNamed nibName: String) -> NSView?
    func add(toView parentView: NSView)
}

extension LoadableView where Self: NSView {
    func load(fromNIBNamed nibName: String) -> NSView? {
        var topLevelObjects: NSArray? = nil
        let nibName = NSNib.Name(stringLiteral: nibName)

        if Bundle.main.loadNibNamed(nibName, owner: self, topLevelObjects: &topLevelObjects) {
            guard let topLevelObjects = topLevelObjects else { return nil }

            return topLevelObjects.first { $0 is NSView } as? NSView
        }

        return nil
    }

    func add(toView parentView: NSView) {
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
