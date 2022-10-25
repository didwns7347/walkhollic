//
//  AppDelegate.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/06.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MAwalkHolic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

/**
 8 12
 3 4
 5 6
 7 8
 2 3
 1 5
 4 8
 1 2
 6 7
 2 3
 7 8
 1 2
 6 7
 당신은 이미 멀리서 교차로의 신호를 분석했기 때문에 횡단보도에 파란불이 들어오는 순서를 알고 있다. 횡단보도의 주기는 총 $M$ 분이며 $1$분마다 신호가 바뀐다. 각 주기의 $1+i (0 \le i < M)$ 번째 신호는 $i, M+i, 2M+i, 3M+i, \cdots$ 분에 시작해서 $1$분 동안 $A_i$번 지역과 $B_i$번 지역을 잇는 횡단보도에 파란불이 들어오고, 다른 모든 횡단보도에는 빨간불이 들어온다. 한 주기 동안 같은 횡단보도에 파란불이 여러 번 들어올 수 있다.

 횡단보도에 파란불이 들어오면 당신은 해당 횡단보도를 이용하여 반대편 지역으로 이동할 수 있으며 이동하는 데 $1$분이 걸린다. 횡단보도를 건너는 도중에 신호가 빨간불이 되면 안되기 때문에 신호가 $s \sim e$ 시간에 들어온다면 반드시 $s \sim e-1$ 시간에 횡단보도를 건너기 시작해야 한다.

 횡단보도와 신호의 정보가 주어질 때, 시간 $0$분 에서 시작해서 $1$번 지역에서 $N$번 지역까지 가는 최소 시간을 구하는 프로그램을 작성하여라.
 */
