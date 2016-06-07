//
//  LinphoneManager.swift
//  linphone-trial
//
//  Created by Cody Liu on 6/7/16.
//  Copyright © 2016 WiAdvance. All rights reserved.
//

import Foundation

//
//  LinphoneManager.swift
//  TestLinphone
//
//  Created by Yevgen on 4/14/15.
//  Copyright (c) 2015 Yevgen Dovgopolyy. All rights reserved.
//

import Foundation




class LinphoneManager {
    
    
    var lct: LinphoneCoreVTable = LinphoneCoreVTable()
    
    var linphonec_vtable: UnsafePointer<LinphoneCoreVTable>?
    var theLinphoneCore: COpaquePointer?
    var configDb: COpaquePointer?
    
    init() {
        let configFilename = documentFile(".linphonerc")
        let factoryConfigFilename = bundleFile("linphonerc-factory")
        
        let configFilenamePtr: UnsafePointer<Int8> = configFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        let factoryConfigFilenamePtr: UnsafePointer<Int8> = factoryConfigFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        
        self.configDb = lp_config_new_with_factory(factoryConfigFilenamePtr, configFilenamePtr)
        
        print(self.configDb)
        
    }
    
    func bundleFile(file: NSString) -> NSString{
        return NSBundle.mainBundle().pathForResource(file.stringByDeletingPathExtension, ofType: file.pathExtension)!
    }
    
    func documentFile(file: NSString) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsPath: NSString = paths[0] as NSString
        return documentsPath.stringByAppendingPathComponent(file as String)
    }
    
    func startLibLinphone() {
        
        
        var v: LinphoneManager = self
        
        let _ : COpaquePointer = withUnsafePointers(&lct, &v, { (ptr: UnsafePointer<LinphoneCoreVTable>, selfPtr: UnsafePointer<LinphoneManager>) -> COpaquePointer in
            
            let voidPtr: UnsafeMutablePointer<Void> = unsafeBitCast(selfPtr, UnsafeMutablePointer<Void>.self)
            return linphone_core_new_with_config (ptr, self.configDb!, voidPtr /* user_data */)
        })
        
    }
}


