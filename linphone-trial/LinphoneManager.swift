import Foundation

enum RegistrationState{
    case LinphoneRegistrationNone       // Initial state for registration
    case LinphoneRegistrationProgress   // Registration is in progress
    case LinphoneRegistrationOk         //Registration is successful
    case LinphoneRegistrationCleared    //Unregistration succeeded
    case LinphoneRegistrationFailed     // Registration failed
    
}

var registrationStateChanged: LinphoneCoreRegistrationStateChangedCb = {
    (p1: COpaquePointer, p2: COpaquePointer, state: LinphoneRegistrationState, message: UnsafePointer<Int8>) in
    
    switch state{
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        NSLog("LinphoneRegistrationNone")
        
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
        
    case LinphoneRegistrationOk:
        NSLog("LinphoneRegistrationOk")
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
        
    default:
        NSLog("Unkown registration state")
    }
}

//LinphoneCoreCallStateChangedCb call_state_changed;
var callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: COpaquePointer, call: COpaquePointer, callSate: LinphoneCallState,  message) in
    

    switch callSate{
//    case LinphoneCallIdle:					/**<Initial call state */
    case LinphoneCallIncomingReceived: /**<This is a new incoming call */
        NSLog("callStateChanged: LinphoneCallIncomingReceived")
        linphone_core_accept_call(lc, call)
        
//    case LinphoneCallOutgoingInit: /**<An outgoing call is started */
//    case LinphoneCallOutgoingProgress: /**<An outgoing call is in progress */
//    case LinphoneCallOutgoingRinging: /**<An outgoing call is ringing at remote end */
//    case LinphoneCallOutgoingEarlyMedia: /**<An outgoing call is proposed early media */
//    case LinphoneCallConnected: /**<Connected, the call is answered */
    case LinphoneCallStreamsRunning: /**<The media streams are established and running*/
        NSLog("callStateChanged: LinphoneCallStreamsRunning")
//    case LinphoneCallPausing: /**<The call is pausing at the initiative of local end */
//    case LinphoneCallPaused: /**< The call is paused, remote end has accepted the pause */
//    case LinphoneCallResuming: /**<The call is being resumed by local end*/
//    case LinphoneCallRefered: /**<The call is being transfered to another party, resulting in a new outgoing call to follow immediately*/
//    case LinphoneCallError: /**<The call encountered an error*/
//    case LinphoneCallEnd: /**<The call ended normally*/
//    case LinphoneCallPausedByRemote: /**<The call is paused by remote end*/
//    case LinphoneCallUpdatedByRemote: /**<The call's parameters change is requested by remote end, used for example when video is added by remote */
//    case LinphoneCallIncomingEarlyMedia: /**<We are proposing early media to an incoming call */
//    case LinphoneCallUpdating: /**<A call update has been initiated by us */
//    case LinphoneCallReleased: /**< The call object is no more retained by the core */
//    case LinphoneCallEarlyUpdatedByRemote: /*<The call is updated by remote while not yet answered (early dialog SIP UPDATE received).*/
//    case LinphoneCallEarlyUpdating: /*<We are updating the call while not yet answered (early dialog SIP UPDATE sent)*/
        
        
    default:
        NSLog("Default call state")
    }}


// LINPHONE_PUBLIC	LinphoneCall * linphone_core_invite_address_with_params(LinphoneCore *lc, const LinphoneAddress *addr, const LinphoneCallParams *params);


//typedef void (*LinphoneCoreRegistrationStateChangedCb)(LinphoneCore *lc, LinphoneProxyConfig *cfg, LinphoneRegistrationState cstate, const char *message) ;

class LinphoneManager {
    
    var lc: COpaquePointer!
    
    var lct: LinphoneCoreVTable = LinphoneCoreVTable()
    var linphonec_vtable: UnsafePointer<LinphoneCoreVTable>?
    
    init() {
        let configFilename = documentFile(".linphonerc")
        let factoryConfigFilename = bundleFile("linphonerc-factory")
        
        let configFilenamePtr: UnsafePointer<Int8> = configFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        let factoryConfigFilenamePtr: UnsafePointer<Int8> = factoryConfigFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        
        lp_config_new_with_factory(factoryConfigFilenamePtr, configFilenamePtr)
        
        linphone_core_enable_logs(nil)
        
        lct.registration_state_changed = registrationStateChanged
        lct.call_state_changed = callStateChanged
        
        /*
         Instanciate a LinphoneCore object given the LinphoneCoreVTable
         */
        lc = linphone_core_new(&lct, nil, nil, nil);
        
        
    }
    
    func bundleFile(file: NSString) -> NSString{
        return NSBundle.mainBundle().pathForResource(file.stringByDeletingPathExtension, ofType: file.pathExtension)!
    }
    
    func documentFile(file: NSString) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsPath: NSString = paths[0] as NSString
        return documentsPath.stringByAppendingPathComponent(file as String)
    }
    
    func demo() {
        register()
        receiveCall()
        shutdown()
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
        
        
        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return
        }
        
        let info=linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(lc!, info); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String.fromCString(linphone_address_get_domain(from)); /*extract domain address from identity*/
        
        NSLog("server_addr: \(server_addr)")
        
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr!); /* we assume domain = proxy server address*/
        linphone_proxy_config_enable_register(proxy_cfg, 1); /*activate registration for this proxy config*/
        linphone_address_destroy(from); /*release resource*/
        linphone_core_add_proxy_config(lc,proxy_cfg); /*add proxy config to linphone core*/
        linphone_core_set_default_proxy_config(lc,proxy_cfg); /*set to default proxy*/
        
    }
    
    func receiveCall(){
        /* main loop for receiving notifications and doing background linphonecore work: */
        for _ in 1...200{
            linphone_core_iterate(lc); /* first iterate initiates registration */
            ms_usleep(50 * 1000);
            NSLog("Waiting call..")
            
        }
    }
    
    func shutdown(){
        var proxy_cfg = linphone_core_get_default_proxy_config(lc); /* get default proxy config*/
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
