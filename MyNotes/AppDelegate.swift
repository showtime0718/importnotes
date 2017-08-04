//
//  AppDelegate.swift
//  MyNotes
//
//  Created by li on 2017/7/4.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //-------------------
    // DB連線變數
    var db: OpaquePointer?
    // 設定全域變數，才能從第一頁帶值，到第二頁
    var appnid: String?
    var appTitle: String?
    var appPhone: String?
    var appAddress: String?
    var appContents: String?
    var appDate: String?
    var color:UIColor = UIColor.black
    //-------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //----------------- 載入資料庫，若無此資料庫則新建，注意！最底下還有關閉資料庫的程式碼
        let fmgr = FileManager.default
        let mydb = Bundle.main.path(forResource: "notesdb", ofType: "sqlite")
        let docDir = NSHomeDirectory() + "/Documents"
        
        print(docDir)
        
        let newdb = docDir + "/notesdb.sqlite"
        
        if !fmgr.fileExists(atPath: docDir + "notesdb.sqlite") {
            do{
                try fmgr.copyItem(atPath: mydb!, toPath: newdb)
            }catch{
                print(error)
            }
        }
        
        if sqlite3_open(newdb, &db) == SQLITE_OK {
            print("db OK")
        }else {
            print("db error")
            db = nil
        }
        //-----------------
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        sqlite3_close(db)
    }
    
}

