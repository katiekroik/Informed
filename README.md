# Informed
=======

Informed is a news app that is aimed at _informing_ the general using. Most people don't actually read the news, or read multiple genres of news, but focus on a few main types that they are interested in. 

Yay.

## Technologies
- [ ] CocoaPods
- [ ] Facebook
- [ ] MongoDB
- [ ] Some news sources API

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
