//
//  Appirater.swift
//  Pods
//
//  Created by Zhou Hao on 09/12/16.
//
//

import Foundation
import StoreKit

let kAppiraterFirstUseDate = "kAppiraterFirstUseDate"
let kAppiraterUseCount = "kAppiraterUseCount"
let kAppiraterSignificantEventCount = "kAppiraterSignificantEventCount"
let kAppiraterCurrentVersion = "kAppiraterCurrentVersion"
let kAppiraterRatedCurrentVersion = "kAppiraterRatedCurrentVersion"
let kAppiraterDeclinedToRate = "kAppiraterDeclinedToRate"
let kAppiraterReminderRequestDate = "kAppiraterReminderRequestDate"

var templateReviewURL = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID"
var templateReviewURLiOS7 = "itms-apps://itunes.apple.com/app/idAPP_ID"
var templateReviewURLiOS8 = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

/*!
 Your localized app's name.
 */
let APPIRATER_LOCALIZED_APP_NAME = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String

/*!
 Your app's name.
 */
let APPIRATER_APP_NAME = APPIRATER_LOCALIZED_APP_NAME ?? (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String) ?? (Bundle.main.infoDictionary!["CFBundleName"] as! String)

/*!
 This is the message your users will see once they've passed the day+launches
 threshold.
 */
let APPIRATER_LOCALIZED_MESSAGE = NSLocalizedString("If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", tableName: "AppiraterLocalizable", bundle: Appirater.bundle(),comment:"")

let APPIRATER_MESSAGE = String(format: APPIRATER_LOCALIZED_MESSAGE, APPIRATER_APP_NAME)

/*!
 This is the title of the message alert that users will see.
 */
let APPIRATER_LOCALIZED_MESSAGE_TITLE = NSLocalizedString("Rate %@", tableName:"AppiraterLocalizable", bundle:Appirater.bundle(), comment:"")

let APPIRATER_MESSAGE_TITLE = String(format: APPIRATER_LOCALIZED_MESSAGE_TITLE, APPIRATER_APP_NAME)

/*!
 The text of the button that rejects reviewing the app.
 */
let APPIRATER_CANCEL_BUTTON = NSLocalizedString("No, Thanks", tableName:"AppiraterLocalizable", bundle:Appirater.bundle(), comment:"")


let APPIRATER_LOCALIZED_RATE_BUTTON = NSLocalizedString("Rate %@", tableName: "AppiraterLocalizable", bundle: Appirater.bundle(), comment: "")
let APPIRATER_RATE_BUTTON = String(format: APPIRATER_LOCALIZED_RATE_BUTTON, APPIRATER_APP_NAME)

/*!
 Text for button to remind the user to review later.
 */
let APPIRATER_RATE_LATER = NSLocalizedString("Remind me later", tableName:"AppiraterLocalizable", bundle:Appirater.bundle(), comment:"")

open class Appirater: NSObject, UIAlertViewDelegate, SKStoreProductViewControllerDelegate {
    
    // MARK: - public properties
    /*!
     Set your Apple generated software id here.
     */
    open static var appId : String {
        get {
            return Appirater.sharedInstance._appId
        }
        set {
            Appirater.sharedInstance._appId = newValue
        }
    }
    
    /*!
     Users will need to have the same version of your app installed for this many
     days before they will be prompted to rate it.
     */
    open static var daysUntilPrompt: Double {
        get {
            return Appirater.sharedInstance._daysUntilPrompt
        }
        set {
            Appirater.sharedInstance._daysUntilPrompt = newValue
        }
    }
    
    /*!
     An example of a 'use' would be if the user launched the app. Bringing the app
     into the foreground (on devices that support it) would also be considered
     a 'use'. You tell Appirater about these events using the two methods:
     [Appirater appLaunched:]
     [Appirater appEnteredForeground:]
     
     Users need to 'use' the same version of the app this many times before
     before they will be prompted to rate it.
     */
    open static var usesUntilPrompt: Int {
        get {
            return Appirater.sharedInstance._usesUntilPrompt
        }
        set {
            Appirater.sharedInstance._usesUntilPrompt = newValue
        }
    }
    
    /*!
     A significant event can be anything you want to be in your app. In a
     telephone app, a significant event might be placing or receiving a call.
     In a game, it might be beating a level or a boss. This is just another
     layer of filtering that can be used to make sure that only the most
     loyal of your users are being prompted to rate you on the app store.
     If you leave this at a value of -1, then this won't be a criterion
     used for rating. To tell Appirater that the user has performed
     a significant event, call the method:
     [Appirater userDidSignificantEvent:];
     */
    open static var significantEventsUntilPrompt: Int {
        get {
            return Appirater.sharedInstance._significantEventsUntilPrompt
        }
        set {
            Appirater.sharedInstance._significantEventsUntilPrompt = newValue
        }
    }
    
    /*!
     Once the rating alert is presented to the user, they might select
     'Remind me later'. This value specifies how long (in days) Appirater
     will wait before reminding them.
     */
    open static var timeBeforeReminding: Double {
        get {
            return Appirater.sharedInstance._timeBeforeReminding
        }
        set {
            Appirater.sharedInstance._timeBeforeReminding = newValue
        }
    }
    
    /*!
     Set customized title for alert view.
     */
    open static var customAlertTitle: String {
        get {
            return Appirater.sharedInstance._alertTitle != "" ? Appirater.sharedInstance._alertTitle : APPIRATER_MESSAGE_TITLE
        }
        set {
            Appirater.sharedInstance._alertTitle = newValue
        }
    }
    
    /*!
     Set customized message for alert view.
     */
    open static var customAlertMessage: String {
        get {
            return Appirater.sharedInstance._alertMessage != "" ? Appirater.sharedInstance._alertMessage : APPIRATER_MESSAGE
        }
        set {
            Appirater.sharedInstance._alertMessage = newValue
        }
    }
    
    
    /*!
     Set customized cancel button title for alert view.
     */
    open static var customAlertCancelButtonTitle: String {
        get {
            return Appirater.sharedInstance._cancelTitle != "" ? Appirater.sharedInstance._cancelTitle : APPIRATER_CANCEL_BUTTON
        }
        set {
            Appirater.sharedInstance._cancelTitle = newValue
        }
    }
    
    /*!
     Set customized rate button title for alert view.
     */
    open static var customAlertRateButtonTitle: String {
        
        get {
            return Appirater.sharedInstance._rateTitle != "" ? Appirater.sharedInstance._rateTitle : APPIRATER_RATE_BUTTON
        }
        set {
            Appirater.sharedInstance._rateTitle = newValue
        }
    }
    
    /*!
     Set customized rate later button title for alert view.
     */
    open static var customAlertRateLaterButtonTitle: String {
        get {
            return Appirater.sharedInstance._rateLaterTitle != "" ? Appirater.sharedInstance._rateLaterTitle : APPIRATER_RATE_LATER
        }
        set {
            Appirater.sharedInstance._rateLaterTitle = newValue
        }
    }
    
    /*!
     'YES' will show the Appirater alert everytime. Useful for testing how your message
     looks and making sure the link to your app's review page works.
     */
    open static var isDebug: Bool {
        get {
           return Appirater.sharedInstance._debug
        }
        set {
            Appirater.sharedInstance._debug = newValue
        }
    }
    
    /*!
     Set whether or not Appirater uses animation (currently respected when pushing modal StoreKit rating VCs).
     */
    open static var isUsesAnimation: Bool {
        get {
            return Appirater.sharedInstance._usesAnimation
        }
        set {
            Appirater.sharedInstance._usesAnimation = newValue
        }
    }
    
    /*!
     If set to YES, Appirater will open App Store link (instead of SKStoreProductViewController on iOS 6). Default YES.
     */
    open static var isOpenInAppStore: Bool {
        get {
            return Appirater.sharedInstance._isOpenInAppStore
        }
        set {
            Appirater.sharedInstance._isOpenInAppStore = newValue
        }
    }
    
    /*!
     If set to YES, the main bundle will always be used to load localized strings.
     Set this to YES if you have provided your own custom localizations in AppiraterLocalizable.strings
     in your main bundle.  Default is NO.
     */
    open static var isAlwaysUseMainBundle: Bool {
        get {
            return Appirater.sharedInstance._alwaysUseMainBundle
        }
        set {
            Appirater.sharedInstance._alwaysUseMainBundle = newValue
        }
    }
    
    /*!
     The bundle localized strings will be loaded from.
     */
    class func bundle() -> Bundle {
        var bundle: Bundle?
        if isAlwaysUseMainBundle {
            bundle = Bundle.main
        }
        else {
            var appiraterBundleURL = Bundle.main.url(forResource: "Appirater", withExtension: "bundle")
            if (appiraterBundleURL != nil) {
                // Appirater.bundle will likely only exist when used via CocoaPods
                bundle = Bundle(url:appiraterBundleURL!)
            } else {
                bundle = Bundle.main
            }
        }
        return bundle!
    }

    class func setStatusBarStyle(_ style: UIStatusBarStyle) {
        Appirater.sharedInstance._statusBarStyle = style
    }

    class func setModalOpen(_ open: Bool) {
        Appirater.sharedInstance._modalOpen = open
    }

    // MARK: private properties
    private var _appId: String = ""
    private var _daysUntilPrompt: Double = 30
    private var _usesUntilPrompt = 20
    private var _significantEventsUntilPrompt = -1
    private var _timeBeforeReminding: Double = 1
    private var _alertTitle: String = ""
    private var _alertMessage: String = ""
    private var _cancelTitle: String = ""
    private var _rateTitle: String = ""
    private var _rateLaterTitle: String = ""
    private var _debug = false
    private var _usesAnimation = true
    private var _isOpenInAppStore = false
    private var _alwaysUseMainBundle = false
    private var _statusBarStyle = UIStatusBarStyle(rawValue: 0)
    private var _modalOpen = false
    
    
    var ratingAlert: UIAlertView!
    var eventQueue = OperationQueue()

    /*!
     Set the delegate if you want to know when Appirater does something
     */
    private weak var _delegate: AppiraterDelegate?

    
    // MARK: life cycle and singletone
    static var sharedInstance = Appirater()
    
    override init() {
        super.init()
        
        if Double(UIDevice.current.systemVersion)! >= 7.0 {
            self._isOpenInAppStore = true
        }
        else {
            self._isOpenInAppStore = false
        }
        
        self.eventQueue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // TODO:
    // MARK: - Alert customization
/*
    override func alertTitle() -> String {
        return alertTitle ? alertTitle : APPIRATER_MESSAGE_TITLE
    }
    
    func alertMessage() -> String {
        return alertMessage ? alertMessage : APPIRATER_MESSAGE
    }
    
    func alertCancelTitle() -> String {
        return alertCancelTitle ? alertCancelTitle : APPIRATER_CANCEL_BUTTON
    }
    
    func alertRateTitle() -> String {
        return alertRateTitle ? alertRateTitle : APPIRATER_RATE_BUTTON
    }
    
    func alertRateLaterTitle() -> String {
        return alertRateLaterTitle ? alertRateLaterTitle : APPIRATER_RATE_LATER
    }
*/
    
    func showRatingAlert(_ displayRateLaterButton: Bool) {
        var alertView: UIAlertView? = nil
        if let delegate = self._delegate {
            if !delegate.appiraterShouldDisplayAlert(self) {
                return
            }
            
            delegate.appiraterDidDisplayAlert(self)
        }
        
        if displayRateLaterButton {
            alertView = UIAlertView(title: Appirater.customAlertTitle, message: Appirater.customAlertMessage, delegate: self, cancelButtonTitle: Appirater.customAlertCancelButtonTitle, otherButtonTitles: Appirater.customAlertRateButtonTitle, Appirater.customAlertRateLaterButtonTitle)
        }
        else {
            alertView = UIAlertView(title: Appirater.customAlertTitle, message: Appirater.customAlertMessage, delegate: self, cancelButtonTitle: Appirater.customAlertCancelButtonTitle, otherButtonTitles: Appirater.customAlertRateButtonTitle)
        }
        self.ratingAlert = alertView
        alertView!.show()
    }
    
    func showRatingAlert() {
        self.showRatingAlert(true)
    }
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        self.closeModal()
    }
    
    // is this an ok time to show the alert? (regardless of whether the rating conditions have been met)
    //
    // things checked here:
    // * connectivity with network
    // * whether user has rated before
    // * whether user has declined to rate
    // * whether rating alert is currently showing visibly
    // things NOT checked here:
    // * time since first launch
    // * number of uses of app
    // * number of significant events
    // * time since last reminder
    func ratingAlertIsAppropriate() -> Bool {
                
        return (Reachability.isConnectedToNetwork() && !self.userHasDeclinedToRate() && !self.ratingAlert.isVisible && !self.userHasRatedCurrentVersion())
    }
    
    
    // have the rating conditions been met/earned? (regardless of whether this would be a moment when it's appropriate to show a new rating alert)
    //
    // things checked here:
    // * time since first launch
    // * number of uses of app
    // * number of significant events
    // * time since last reminder
    // things NOT checked here:
    // * connectivity with network
    // * whether user has rated before
    // * whether user has declined to rate
    // * whether rating alert is currently showing visibly
    func ratingConditionsHaveBeenMet() -> Bool {
        if Appirater.sharedInstance._debug {
            return true
        }
        var userDefaults = UserDefaults.standard
        var dateOfFirstLaunch = Date(timeIntervalSince1970: userDefaults.double(forKey: kAppiraterFirstUseDate))
        var timeSinceFirstLaunch = Date().timeIntervalSince(dateOfFirstLaunch)
        var timeUntilRate = 60 * 60 * 24 * Appirater.daysUntilPrompt
        if timeSinceFirstLaunch < timeUntilRate {
            return false
        }
        // check if the app has been used enough
        var useCount = userDefaults.integer(forKey: kAppiraterUseCount)
        if useCount < Appirater.usesUntilPrompt {
            return false
        }
        // check if the user has done enough significant events
        var sigEventCount = userDefaults.integer(forKey: kAppiraterSignificantEventCount)
        if sigEventCount < Appirater.significantEventsUntilPrompt {
            return false
        }
        
        // if the user wanted to be reminded later, has enough time passed?
        var reminderRequestDate = Date(timeIntervalSince1970: userDefaults.double(forKey: kAppiraterReminderRequestDate))
        var timeSinceReminderRequest = Date().timeIntervalSince(reminderRequestDate)
        var timeUntilReminder = 60 * 60 * 24 * Appirater.timeBeforeReminding
        if timeSinceReminderRequest < timeUntilReminder {
            return false
        }
        return true
    }
    
    func incrementUseCount() {
        // get the app's version
        var version = (Bundle.main.infoDictionary![(kCFBundleVersionKey as! String)] as! String)
        // get the version number that we've been tracking
        var userDefaults = UserDefaults.standard
        var trackingVersion = userDefaults.string(forKey: kAppiraterCurrentVersion)!
        if trackingVersion == nil {
            trackingVersion = version
            userDefaults.set(version, forKey: kAppiraterCurrentVersion)
        }
        if Appirater.sharedInstance._debug {
            print("APPIRATER Tracking version: \(trackingVersion)")
        }

        if (trackingVersion == version) {
            // check if the first use date has been set. if not, set it.
            var timeInterval = userDefaults.double(forKey: kAppiraterFirstUseDate)
            if timeInterval == 0 {
                timeInterval = Date().timeIntervalSince1970
                userDefaults.set(timeInterval, forKey: kAppiraterFirstUseDate)
            }
            // increment the use count
            var useCount = userDefaults.integer(forKey: kAppiraterUseCount)
            useCount += 1
            userDefaults.set(useCount, forKey: kAppiraterUseCount)
            if Appirater.sharedInstance._debug {
                print("APPIRATER Use count: \(useCount)")
            }
        } else {
            userDefaults.set(version, forKey: kAppiraterCurrentVersion)
            userDefaults.set(Date().timeIntervalSince1970, forKey: kAppiraterFirstUseDate)
            userDefaults.set(1, forKey: kAppiraterUseCount)
            userDefaults.set(0, forKey: kAppiraterSignificantEventCount)
            userDefaults.set(false, forKey: kAppiraterRatedCurrentVersion)
            userDefaults.set(false, forKey: kAppiraterDeclinedToRate)
            userDefaults.set(0, forKey: kAppiraterReminderRequestDate)
        }
        
        userDefaults.synchronize()
    }
    
    func incrementSignificantEventCount() {
        // get the app's version
        var version = (Bundle.main.infoDictionary![(kCFBundleVersionKey as! String)] as! String)
        // get the version number that we've been tracking
        var userDefaults = UserDefaults.standard
        var trackingVersion = userDefaults.string(forKey: kAppiraterCurrentVersion)
        if trackingVersion == nil {
            trackingVersion = version
            userDefaults.set(version, forKey: kAppiraterCurrentVersion)
        }
        if Appirater.sharedInstance._debug {
            print("APPIRATER Tracking version: \(trackingVersion)")
        }
        
        if (trackingVersion == version) {
            // check if the first use date has been set. if not, set it.
            var timeInterval = userDefaults.double(forKey: kAppiraterFirstUseDate)
            if timeInterval == 0 {
                timeInterval = Date().timeIntervalSince1970
                userDefaults.set(timeInterval, forKey: kAppiraterFirstUseDate)
            }
            // increment the significant event count
            var sigEventCount = userDefaults.integer(forKey: kAppiraterSignificantEventCount)
            sigEventCount += 1
            userDefaults.set(sigEventCount, forKey: kAppiraterSignificantEventCount)
            if Appirater.sharedInstance._debug {
                print("APPIRATER Significant event count: \(sigEventCount)")
            }
        } else {
            // it's a new version of the app, so restart tracking
            userDefaults.set(version, forKey: kAppiraterCurrentVersion)
            userDefaults.set(0, forKey: kAppiraterFirstUseDate)
            userDefaults.set(0, forKey: kAppiraterUseCount)
            userDefaults.set(1, forKey: kAppiraterSignificantEventCount)
            userDefaults.set(false, forKey: kAppiraterRatedCurrentVersion)
            userDefaults.set(false, forKey: kAppiraterDeclinedToRate)
            userDefaults.set(0, forKey: kAppiraterReminderRequestDate)
        }

        userDefaults.synchronize()
    }
    
    func incrementAndRate(_ canPromptForRating: Bool) {
        self.incrementUseCount()
        if canPromptForRating && self.ratingConditionsHaveBeenMet() && self.ratingAlertIsAppropriate() {
            DispatchQueue.main.async(execute: {() -> Void in
                self.showRatingAlert()
            })
        }
    }
    
    func incrementSignificantEventAndRate(_ canPromptForRating: Bool) {
        self.incrementSignificantEventCount()
        if canPromptForRating && self.ratingConditionsHaveBeenMet() && self.ratingAlertIsAppropriate() {
            DispatchQueue.main.async(execute: {() -> Void in
                self.showRatingAlert()
            })
        }
    }
    
    /*!
     Asks Appirater if the user has declined to rate;
     */
    func userHasDeclinedToRate() -> Bool {
        return UserDefaults.standard.bool(forKey: kAppiraterDeclinedToRate)
    }
    
    /*!
     Asks Appirater if the user has rated the current version.
     Note that this is not a guarantee that the user has actually rated the app in the
     app store, but they've just clicked the rate button on the Appirater dialog.
     */
    func userHasRatedCurrentVersion() -> Bool {
        return UserDefaults.standard.bool(forKey: kAppiraterRatedCurrentVersion)
    }
    
    open class func appLaunched() {
        Appirater.appLaunched(true)
    }
    
    func hideRatingAlert() {
        if self.ratingAlert.isVisible {
            if Appirater.sharedInstance._debug {
                print("APPIRATER Hiding Alert")
            }
            self.ratingAlert.dismiss(withClickedButtonIndex: -1, animated: false)
        }
    }
    
    /*!
     Tells Appirater that the app has launched, and on devices that do NOT
     support multitasking, the 'uses' count will be incremented. You should
     call this method at the end of your application delegate's
     application:didFinishLaunchingWithOptions: method.
     
     If the app has been used enough to be rated (and enough significant events),
     you can suppress the rating alert
     by passing NO for canPromptForRating. The rating alert will simply be postponed
     until it is called again with YES for canPromptForRating. The rating alert
     can also be triggered by appEnteredForeground: and userDidSignificantEvent:
     (as long as you pass YES for canPromptForRating in those methods).
     */
    open class func appLaunched(_ canPromptForRating: Bool) {
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            var a = Appirater.sharedInstance
            if a._debug {
                DispatchQueue.main.async(execute: {() -> Void in
                    a.showRatingAlert()
                })
            }
            else {
                a.incrementAndRate(canPromptForRating)
            }
        })
    }
    
    
    func appWillResignActive() {
        if Appirater.sharedInstance._debug {
            print("APPIRATER appWillResignActive")
        }
        Appirater.sharedInstance.hideRatingAlert()
    }
    
    class func showPrompt() {
        Appirater.tryToShowPrompt()
    }
    
    func showPrompt(withChecks: Bool, displayRateLaterButton: Bool) {
        if withChecks == false || self.ratingAlertIsAppropriate() {
            self.showRatingAlert(displayRateLaterButton)
        }
    }
    
    class func getRootViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow!
        if window.windowLevel != UIWindowLevelNormal {
            var windows = UIApplication.shared.windows
            for window in windows {
                if window.windowLevel == UIWindowLevelNormal {
                    break
                }
            }
        }
        return Appirater.iterateSubViews(forViewController: window)
    }
    
    class func iterateSubViews(forViewController parentView: UIView) -> UIViewController? {
        for subView: UIView in parentView.subviews {
            var responder = subView.next!
            if (responder is UIViewController) {
                return self.topMostViewController((responder as! UIViewController))
            }
            var found = Appirater.iterateSubViews(forViewController: subView)
            if nil != found {
                return found
            }
        }
        return nil
    }
    
    class func topMostViewController(_ controller: UIViewController) -> UIViewController {
        var topController = controller
        var isPresenting = false
        repeat {
            // this path is called only on iOS 6+, so -presentedViewController is fine here.
            var presented = controller.presentedViewController
            isPresenting = presented != nil
            if presented != nil {
                topController = presented!
            }
        } while isPresenting
        return topController
    }
    
    public func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var userDefaults = UserDefaults.standard
        var delegate = self._delegate
        switch buttonIndex {
            
        case 0:
            // they don't want to rate it
            userDefaults.set(true, forKey: kAppiraterDeclinedToRate)
            userDefaults.synchronize()
            delegate?.appiraterDidDecline(toRate: self)
            
        case 1:
            // they want to rate it
            Appirater.rateApp()
            delegate?.appiraterDidOpt(toRate: self)
            
        case 2:
            // remind them later
            userDefaults.set(Date().timeIntervalSince1970, forKey: kAppiraterReminderRequestDate)
            
        default:
            userDefaults.set(true, forKey: kAppiraterDeclinedToRate)
            userDefaults.synchronize()
            delegate?.appiraterDidDecline(toRate: self)
        }
    }
    
    /*!
     Tells Appirater that the app was brought to the foreground on multitasking
     devices. You should call this method from the application delegate's
     applicationWillEnterForeground: method.
     
     If the app has been used enough to be rated (and enough significant events),
     you can suppress the rating alert
     by passing NO for canPromptForRating. The rating alert will simply be postponed
     until it is called again with YES for canPromptForRating. The rating alert
     can also be triggered by appLaunched: and userDidSignificantEvent:
     (as long as you pass YES for canPromptForRating in those methods).
     */
    open class func appEnteredForeground(_ canPromptForRating: Bool) {
        var a = Appirater.sharedInstance
        a.eventQueue.addOperation {() -> Void in
            Appirater.sharedInstance.incrementAndRate(canPromptForRating)
        }
    }
    
    /*!
     Tells Appirater that the user performed a significant event. A significant
     event is whatever you want it to be. If you're app is used to make VoIP
     calls, then you might want to call this method whenever the user places
     a call. If it's a game, you might want to call this whenever the user
     beats a level boss.
     
     If the user has performed enough significant events and used the app enough,
     you can suppress the rating alert by passing NO for canPromptForRating. The
     rating alert will simply be postponed until it is called again with YES for
     canPromptForRating. The rating alert can also be triggered by appLaunched:
     and appEnteredForeground: (as long as you pass YES for canPromptForRating
     in those methods).
     */
    open class func userDidSignificantEvent(_ canPromptForRating: Bool) {
        var a = Appirater.sharedInstance
        a.eventQueue.addOperation {() -> Void in
            Appirater.sharedInstance.incrementSignificantEventAndRate(canPromptForRating)
        }
    }
    
    /*!
     Tells Appirater to try and show the prompt (a rating alert). The prompt will be showed
     if there is connection available, the user hasn't declined to rate
     or hasn't rated current version.
     
     You could call to show the prompt regardless Appirater settings,
     e.g., in case of some special event in your app.
     */
    class func tryToShowPrompt() {
        Appirater.sharedInstance.showPrompt(withChecks: true, displayRateLaterButton: true)
    }
    
    /*!
     Tells Appirater to show the prompt (a rating alert).
     Similar to tryToShowPrompt, but without checks (the prompt is always displayed).
     Passing false will hide the rate later button on the prompt.
     
     The only case where you should call this is if your app has an
     explicit "Rate this app" command somewhere. This is similar to rateApp,
     but instead of jumping to the review directly, an intermediary prompt is displayed.
     */
    class func forceShowPrompt(_ displayRateLaterButton: Bool) {
        Appirater.sharedInstance.showPrompt(withChecks: false, displayRateLaterButton: displayRateLaterButton)
    }
    
    /*!
     Tells Appirater to open the App Store page where the user can specify a
     rating for the app. Also records the fact that this has happened, so the
     user won't be prompted again to rate the app.
     The only case where you should call this directly is if your app has an
     explicit "Rate this app" command somewhere.  In all other cases, don't worry
     about calling this -- instead, just call the other functions listed above,
     and let Appirater handle the bookkeeping of deciding when to ask the user
     whether to rate the app.
     */
    class func rateApp() {
        var userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: kAppiraterRatedCurrentVersion)
        userDefaults.synchronize()
        //Use the in-app StoreKit view if available (iOS 6) and imported. This works in the simulator.
        if !Appirater.sharedInstance._isOpenInAppStore && NSStringFromClass(SKStoreProductViewController.self) != nil {
            var storeViewController = SKStoreProductViewController()
            var appId = Int(self.appId)
            storeViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appId], completionBlock: nil)
            storeViewController.delegate = self.sharedInstance
            var delegate = self.sharedInstance._delegate
            
            delegate?.appiraterWillPresentModalView(self.sharedInstance, animated: Appirater.sharedInstance._usesAnimation)
            
            self.getRootViewController()?.present(storeViewController, animated: self.sharedInstance._usesAnimation, completion: {() -> Void in
                self.sharedInstance._modalOpen = true
            })
        } else {
            
            #if TARGET_IPHONE_SIMULATOR
                print("APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.")
            #else
                var reviewURL = templateReviewURL.replacingOccurrences(of: "APP_ID", with: "\(appId)")
                // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
                // Fixes condition @see https://github.com/arashpayan/appirater/issues/205
                if Double(UIDevice.current.systemVersion)! >= 7.0 && Double(UIDevice.current.systemVersion)! < 8.0 {
                    reviewURL = templateReviewURLiOS7.replacingOccurrences(of: "APP_ID", with: "\(appId)")
                }
                else if Double(UIDevice.current.systemVersion)! >= 8.0 {
                    reviewURL = templateReviewURLiOS8.replacingOccurrences(of: "APP_ID", with: "\(appId)")
                }
                
                UIApplication.shared.openURL(URL(string: reviewURL)!)
            #endif
        }

    }
    
    /*!
     Tells Appirater to immediately close any open rating modals (e.g. StoreKit rating VCs).
     */
    func closeModal() {
        if _modalOpen {
            var usedAnimation = _usesAnimation
            self._modalOpen = false
            // get the top most controller (= the StoreKit Controller) and dismiss it
            var presentingController = UIApplication.shared.keyWindow!.rootViewController!
            presentingController = Appirater.topMostViewController(presentingController)
            presentingController.dismiss(animated: _usesAnimation, completion: {() -> Void in
                if let delegate = Appirater.sharedInstance._delegate {
                    delegate.appiraterDidDismissModalView((self as! Appirater), animated: usedAnimation)
                }
            })
            self._statusBarStyle = .none
        }
    }
}


