# Informed

Informed is a news app that is aimed at _informing_ the general using. Most people don't actually read the news, or read multiple genres of news, but focus on a few main types that they are interested in. 

Since we've only had a few weeks to do so, we haven't completed everything we want to do. Implementing the basic features took a lot of our time, so we haven't gotten up to the lofty goals we had set out originally to do. Instead, these are what we're using:

### Technologies
- [x] CocoaPods - to install dependencies
- [x] Facebook - to handle logins
- [x] Realm - the database that keeps track of users
- [ ] Alamofire - to create API requests
- [ ] The Guardian - to get news from

### Setting Up Our App
- [ ] Install CocoaPods - if not done so already : `sudo gem install cocoapods`
- [ ] Download the project
- [ ] Run `pod install`
- [ ] Use the `.xcworkspace` file that's automatically generated to develop
- [ ] Insert some mock data in the DB

##### Using CocoaPods in General
Cocoa Pods are like the npm of Swift, which basically let you quickly install all the backage dependencies. The way it works is:
- [ ] Install CocoaPods on your computer: `sudo gem install cocoapods`
- [ ] Make a podfile (which this project already has). They generally look like
``` 
target '[YourProject]' do
        use_frameworks!
        pod '[Your Framework]'
end
```
- [ ] run `pod install`
- [ ] Use the `.xcworkspace` file that's automatically generated to develop

##### How We Did the Facebook Login
- [x] Imported the FB SDK, the `FBSDKCoreKid.framework`
- [x] Registered the app on [developers.facebook.com](developers.facebook.com) with ID `1322094234473271`
- [x] Connected the App Delegate to the `FBSDKApplicationDelegate` to access the facebook app in `AppDelegate.swift` and created a bridging header, `Informed-Bridging-Header.h`, to import the appropriate files
- [x] In `AppDelegate.swift`, first check if the user is active by checking if `FBSDKAccessToken.currentAccessToken() == nil`. Depending on this, the app will show the login page or the main view controller.
- [x] In `FBViewController.swift`, created function `fetchProfile()` that grabs email, first name, last name, and profile picture of the user. (will use this info in database)
- [ ] Create a user object with the FB email - if one doesn't exist already
- [x] Finally, after logging in successfully the app will switch back to main view controller (`TabViewController`).
- [x] Logout action button on `SecondViewController` takes user back to `FBViewController` where the logout button is now present.

