//
//  AppDelegate.swift
//  Nest
//
//  Created by Clara Jeon on 2/8/21.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

public var challengeArray: [Challenge] = []
@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //to use Firebase in our app
        FirebaseApp.configure()
        
        //for google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        return true
    }
    
    //for google sign in
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            //Authentication error
            if let error = error {
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            }
            
            let isNewUser = authResult?.additionalUserInfo?.isNewUser
            
            if isNewUser ?? false {
                //storing profile in database passing info to a func in Database Manager
                let firstName = user.profile.givenName ?? "firstName"
                let lastName = user.profile.familyName ?? "lastName"
                let profilePhotoImage = GIDSignIn.sharedInstance()?.currentUser.profile.hasImage
                
                var profilePhotoUrl: URL?
                
                //when user has a google profile image
                if (profilePhotoImage ?? false){
                    let googleProfilePhotoUrl = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 400)?.absoluteString
                    
                    StorageManager.shared.uploadGoogleUrlProfilePhoto(googleProfilePhotoUrl!) { (url) in
                        profilePhotoUrl = url
                        print("success in uploading google prof pic")
                        DatabaseManager.shared.insertNewUser(firstName: firstName, lastName: lastName, profilePhotoUrl: profilePhotoUrl!) { (success) in
                            print("success signing in")
                            // Post notification after user successfully sign in
                            NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
                        }
                    }
                }
                
                //when user does not have google profile image, set profile pic to a default one
                else {
                    let defaultProfilePhoto = #imageLiteral(resourceName: "blankprofilepic")
                    
                    StorageManager.shared.uploadGeneralProfilePhoto(defaultProfilePhoto) { (url) in
                        profilePhotoUrl = url
                        print("success in uploading prof pic")
                        DatabaseManager.shared.insertNewUser(firstName: firstName, lastName: lastName, profilePhotoUrl: profilePhotoUrl!) { (success) in
                            print("success signing in")
                            // Post notification after user successfully sign in
                            NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
                        }
                    }
                }
            }
            else {
                NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
            }
            
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


