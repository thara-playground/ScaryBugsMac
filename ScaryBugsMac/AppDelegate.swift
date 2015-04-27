//
//  AppDelegate.swift
//  ScaryBugsMac
//
//  Created by Tomochika Hara on 2015/04/28.
//  Copyright (c) 2015年 isuka.org. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var masterViewController: MasterViewController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        
        self.window.contentView.addSubview(self.masterViewController.view)
        self.masterViewController.view.frame = (window.contentView as! NSView).bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

