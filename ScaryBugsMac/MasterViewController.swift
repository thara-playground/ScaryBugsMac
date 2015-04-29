//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by Tomochika Hara on 2015/04/28.
//  Copyright (c) 2015年 isuka.org. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    var bugs = [ScaryBugDoc]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setupSampleBugs() {
        let bug1 = ScaryBugDoc(title: "Potato bug", rating: 4.0,
            thumbImage: NSImage(named: "potatoBugThumb"), fullImage: NSImage(named: "potatoBug"))
        let bug2 = ScaryBugDoc(title: "House centipedeThumb", rating: 3.0,
            thumbImage: NSImage(named: "centipedeThumb"), fullImage: NSImage(named: "centipede"))
        let bug3 = ScaryBugDoc(title: "Wolf spider", rating: 5.0,
            thumbImage: NSImage(named: "wolfSpiderThumb"), fullImage: NSImage(named: "wolfSpider"))
        let bug4 = ScaryBugDoc(title: "Lady bug", rating: 1.0,
            thumbImage: NSImage(named: "ladybugThumb"), fullImage: NSImage(named: "ladybug"))
        
        self.bugs = [bug1, bug2, bug3, bug4]
    }
}

// MARK: - NSTableViewDataSource
extension MasterViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.bugs.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        if tableColumn!.identifier == "BugColumn" {
            let bugDoc = self.bugs[row]
            cellView.imageView!.image = bugDoc.thumbImage
            cellView.textField!.stringValue = bugDoc.data.title
            return cellView
        }
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension MasterViewController: NSTableViewDelegate {
}
