# linphone-swift-demo

[linephone](https://www.linphone.org/) is a open source VOIP project.In this repository, we demonstrate how to integrate [liblinphone](http://www.linphone.org/technical-corner/liblinphone/overview) into a swift project. We include 3 common scenarios: 

- make a phone call
- auto pick an incoming phone call
- registration and idle 

## Usage

1. Remember to modify Secret.plist to your account

2. Modify `demo()` in `LinphoneManager.swift` to test different scenario like call out or pick an incoming call. 
        
3. Run the app, look your text console to get the linphone output details.

## Example 

Make a sip call:

    let calleeAccount = "CALLEE_SIP_NUMBER" // ex: 0702552520
    ...
    func demo() {
        makeCall()
    }   
         
## Sample linephone output in console

![](https://i.imgur.com/HUs8kGx.png)

## More information

- [Build liblinphone-sdk library file for iOS](http://blog.codylab.com/ios-build-linphone-iphone-sdk/)
- [(Chinese) 在 iOS/Swift中使用 liblinphone 函式庫](http://blog.codylab.com/ios-liblinphone-setup/)
- [(Chinese) 使用 linphone 函式庫發生 exc_bad_access 的除錯經驗](http://blog.codylab.com/ios-linphone-exc-bad-access/)

## License

The content of this repository is licensed under a [Creative Commons Attribution License](http://creativecommons.org/licenses/by/3.0/us/)