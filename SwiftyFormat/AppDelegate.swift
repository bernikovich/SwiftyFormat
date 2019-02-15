//
//  Created by Tsimur Bernikovich on 2/15/19.
//  Copyright © 2019 Tsimur Bernikovich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    self.window = window
    
    return true
  }
  
}
