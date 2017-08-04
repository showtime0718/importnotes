//
//  ViewController.swift
//  MyNotes
//
//  Created by li on 2017/7/4.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let appMain = UIApplication.shared.delegate as! AppDelegate
    var notes:[String] = Array()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notes.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = notes[indexPath.row]
        
        return cell!
    }
    
    // 點擊 tableView 的 cell 前去編輯記事本
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = notes[indexPath.row]
        
        let sql = "SELECT * FROM notes WHERE title = '\(title)'"
        var point:OpaquePointer? = nil
        if sqlite3_prepare(appMain.db, sql, -1, &point, nil) == SQLITE_OK {
            print("tableView Update Select OK")
        }
        
        while sqlite3_step(point) == SQLITE_ROW {
            let nid = sqlite3_column_text(point, 0)
            let title = sqlite3_column_text(point, 1)
            let phone = sqlite3_column_text(point, 2)
            let address = sqlite3_column_text(point, 3)
            let contents = sqlite3_column_text(point, 4)
            let date = sqlite3_column_text(point, 5)
            
            appMain.appnid = String(cString: nid!)
            appMain.appTitle = String(cString: title!)
            appMain.appPhone = String(cString: phone!)
            appMain.appAddress = String(cString: address!)
            appMain.appContents = String(cString: contents!)
            appMain.appDate = String(cString: date!)

        }
        if let editPage = storyboard?.instantiateViewController(withIdentifier: "editPage"){
            show(editPage, sender: self)
        }
    }
    
    
    @IBAction func addText(_ sender: Any) {
        if let textVC = self.storyboard?.instantiateViewController(withIdentifier: "editPage"){
            appMain.appnid = nil
            appMain.appTitle = nil
            appMain.appPhone = nil
            appMain.appAddress = nil
            appMain.appContents = nil
            appMain.appDate = nil
            
            show(textVC, sender: self)
        }
    }
    
    @IBAction func editPageLeave(for segue: UIStoryboardSegue) {
        print("text leave")
        appMain.appnid = nil
        appMain.appTitle = nil
        appMain.appPhone = nil
        appMain.appAddress = nil
        appMain.appContents = nil
        appMain.appDate = nil
        
    }
    
    func showTableView() {
        
        self.appMain.appnid = nil
        self.appMain.appTitle = nil
        self.appMain.appContents = nil
        self.appMain.appDate = nil
        
        let sql = "SELECT * FROM notes"
        var point:OpaquePointer? = nil
        if sqlite3_prepare(appMain.db, sql, -1, &point, nil) == SQLITE_OK {
            print("Select OK")
        }
        
        while sqlite3_step(point) == SQLITE_ROW {
            let title = sqlite3_column_text(point, 1) // 抓指定欄位
            let str = String(cString: title!)
            
            notes += [str]
        }
        
    }
    
    @IBAction func searchBarBtn(_ sender: Any) {
        //let sqlTitle = "SELECT * FROM notes WHERE title = "
//        var selectAlertField: String?
//        
//        let alert = UIAlertController(title: "請輸入要搜尋的記事標題", message:
//            nil, preferredStyle: UIAlertControllerStyle.alert)
//        
//        alert.addTextField(configurationHandler: {(textField: UITextField) -> Void in
//            textField.placeholder = "請輸入要查詢的記事標題"
//        })
//
//        
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: {(action) -> Void in
//            
//            print(selectAlertField!)
//        
//        }))
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 返回歡迎頁時，tableView重載
    override func viewWillAppear(_ animated: Bool) {
        notes = []  // 陣列清空，不然會有上一次載入的陣列
        self.tableView.reloadData(showTableView())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

