# Informed

Informed is a news app that is aimed at _informing_ the general using. Most people don't actually read the news, or read multiple genres of news, but focus on a few main types that they are interested in. 

Since we've only had a few weeks to do so, we haven't completed everything we want to do. Implementing the basic features took a lot of our time, so we haven't gotten up to the lofty goals we had set out originally to do. Instead, these are what we're using:

### Technologies
- [ ] CocoaPods - to install dependencies
- [ ] Facebook - to handle logins
- [ ] Realm - the database that keeps track of users
- [ ] Alamofire - to create API requests
- [ ] The Guardian - to get news from

#### Using CocoaPods
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
