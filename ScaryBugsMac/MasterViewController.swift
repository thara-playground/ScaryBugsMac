//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by Tomochika Hara on 2015/04/28.
//  Copyright (c) 2015年 isuka.org. All rights reserved.
//

import Cocoa
import Quartz

class MasterViewController: NSViewController {

    @IBOutlet weak var bugsTableView: NSTableView!
    @IBOutlet weak var bugTitleView: NSTextField!
    @IBOutlet weak var bugImageView: NSImageView!
    @IBOutlet weak var bugRating: EDStarRating!
    
    var bugs = [ScaryBugDoc]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        self.bugRating.starImage = NSImage(named: "star.png")
        self.bugRating.starHighlightedImage = NSImage(named: "shockedface2_full.png")
        self.bugRating.starImage = NSImage(named: "shockedface2_empty.png")

        self.bugRating.delegate = self

        self.bugRating.maxRating = 5
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = true
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)
        self.bugRating.rating = Float(0.0)
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
    
    func selectedBugDoc() -> ScaryBugDoc? {
        let selectedRow = self.bugsTableView.selectedRow
        if 0 <= selectedRow && selectedRow < self.bugs.count {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    func updateDetailInfo(doc: ScaryBugDoc?) {
        var title = ""
        var image: NSImage?
        var rating = 0.0
        
        if let scaryBugDoc = doc {
            title = scaryBugDoc.data.title
            image = scaryBugDoc.fullImage
            rating = scaryBugDoc.data.rating
        }
        
        self.bugTitleView.stringValue = title
        self.bugImageView.image = image
        self.bugRating.rating = Float(rating)
    }
    
    func reloadSelectedBugRow() {
        let indexSet =  NSIndexSet(index: self.bugsTableView.selectedRow)
        let columnSet = NSIndexSet(index: 0)
        self.bugsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
    }
}


// MARK: - IBActions
extension MasterViewController {
    
    @IBAction func bugTitleDidEndEdit(sender: AnyObject) {
        if let selectedDoc = self.selectedBugDoc() {
            selectedDoc.data.title = self.bugTitleView.stringValue
            self.reloadSelectedBugRow()
        }
    }
    
    @IBAction func addBug(sender: AnyObject) {
        let newDoc = ScaryBugDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil)
        
        self.bugs.append(newDoc)
        let newRowIndex = self.bugs.count - 1
        
        self.bugsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        
        self.bugsTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection: false)
        self.bugsTableView.scrollRowToVisible(newRowIndex)
    }
    
    @IBAction func deleteBug(sender: AnyObject) {
        if let selectedDoc = self.selectedBugDoc() {
            self.bugs.removeAtIndex(self.bugsTableView.selectedRow)
            
            self.bugsTableView.removeRowsAtIndexes(NSIndexSet(index: self.bugsTableView.selectedRow), withAnimation: NSTableViewAnimationOptions.SlideRight)
            
            self.updateDetailInfo(nil)
        }
    }
    
    @IBAction func changePicture(sender: AnyObject) {
        if let selectedDoc = self.selectedBugDoc() {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window, withDelegate: self, didEndSelector: "pictureTakerDidEnd:returnCode:contextInfo:", contextInfo: nil)
        }
    }
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        
        if image != nil && returnCode == NSModalResponseOK {
            self.bugImageView.image = image
            if let selectedDoc = self.selectedBugDoc() {
                selectedDoc.fullImage = image
                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44))
                self.selectedBugDoc()
            }
        }
    }
}

// MARK: - NSTableViewDataSource
extension MasterViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.bugs.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
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
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = self.selectedBugDoc()
        self.updateDetailInfo(selectedDoc)
    }
}

// MARK: - EDStarRatingProtocol
extension MasterViewController: EDStarRatingProtocol {
    func starsSelectionChanged(control: EDStarRating!, rating: Float) {
        if let selectedDoc = self.selectedBugDoc() {
            selectedDoc.data.rating = Double(self.bugRating.rating)
        }
    }
}