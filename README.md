# linphone-swift-demo

[linphone](https://www.linphone.org/) is a open source VOIP project.In this repository, we demonstrate how to integrate [liblinphone](http://www.linphone.org/technical-corner/liblinphone/overview) library into a swift project. We include 3 common scenarios:

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

MIT License

Copyright (c) 2017

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.