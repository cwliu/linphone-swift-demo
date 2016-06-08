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
        
        linphone_core_enable_logs(nil)
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
        register()
    }
    
    func register(){
        
        // Reference: http://www.linphone.org/docs/liblinphone/group__registration__tutorials.html
        
        let path = NSBundle.mainBundle().pathForResource("Secret", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let account = dict?.objectForKey("account") as! String
        let password = dict?.objectForKey("password") as! String
        let domain = dict?.objectForKey("domain") as! String
        
        let identity = "sip:" + account + "@" + domain;
        
        
        /*
         Fill the LinphoneCoreVTable with application callbacks.
         All are optional. Here we only use the registration_state_changed callbacks
         in order to get notifications about the progress of the registration.
         */
        // lct.registration_state_changed = registration_state_changed;
        
        
        /*
         Instanciate a LinphoneCore object given the LinphoneCoreVTable
         */
        let lc = linphone_core_new(&lct, nil, nil, nil);
        
        
        /*create proxy config*/
        var proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return
        }
        
        let info=linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(lc, info); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String.fromCString(linphone_address_get_domain(from)); /*extract domain address from identity*/
        
        NSLog("server_addr: \(server_addr)")
        
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr!); /* we assume domain = proxy server address*/
        linphone_proxy_config_enable_register(proxy_cfg, 1); /*activate registration for this proxy config*/
        linphone_address_destroy(from); /*release resource*/
        linphone_core_add_proxy_config(lc,proxy_cfg); /*add proxy config to linphone core*/
        
        linphone_core_set_default_proxy_config(lc,proxy_cfg); /*set to default proxy*/
        
        /* main loop for receiving notifications and doing background linphonecore work: */
        for _ in 1...200{
            linphone_core_iterate(lc); /* first iterate initiates registration */
            ms_usleep(50 * 1000);
            NSLog("Waiting call..")

        }
        
        proxy_cfg = linphone_core_get_default_proxy_config(lc); /* get default proxy config*/
        linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
        linphone_proxy_config_enable_register(proxy_cfg, 0); /*de-activate registration for this proxy config*/
        linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
        while(linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationCleared){
            linphone_core_iterate(lc); /*to make sure we receive call backs before shutting down*/
            ms_usleep(50000);
        }
        
        NSLog("Shutdown..")
        linphone_core_destroy(lc);
    }
}
