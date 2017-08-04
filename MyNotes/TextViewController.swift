//
//  TextViewController.swift
//  MyNotes
//
//  Created by li on 2017/7/4.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
// 取得 AppDelegate 物件，此物件有全域變數
    let appMain = UIApplication.shared.delegate as! AppDelegate
    
    let fontSizeList: Array = ["10", "14", "18", "20", "24", "28"]
    
    private var closeKeyboardBtn:UIButton?
    var vc2image:UIImage?
    
    @IBAction func draw(_ sender: Any) {
        let p2 =  self.storyboard?.instantiateViewController(withIdentifier: "drawVC") as! drawVC // 製作drawVC物件實體
        p2.vc1controller = self
        self.navigationController?.pushViewController(p2, animated: true)
        
    }
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tool: UIToolbar!
    @IBOutlet weak var moreStackView: UIStackView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textViewPlaceholderLabel: UILabel!
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontSizeList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontSizeList[row]
    }
// 拍照
    @IBAction func camera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePikerVC = UIImagePickerController()
            //設定相片來源為相機
            imagePikerVC.sourceType = .camera
            imagePikerVC.delegate = self
            show(imagePikerVC , sender:self)
            
        }
        print("拍照")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //取得拍下的照片
        let image = info[UIImagePickerControllerOriginalImage] as!  UIImage
        
        
        //將相片存擋
        var attributedString : NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let oldWidth = textAttachment.image!.size.width
        let scaleFactor = oldWidth / (textView.frame.size.width - 200)//大小
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attStringWithImage)
        textView.attributedText = attributedString
        
        
        dismiss(animated: true, completion: nil)
        let imagedata = UIImagePNGRepresentation(image)
        let compresedimage = UIImage(data: imagedata!)
        UIImageWriteToSavedPhotosAlbum(compresedimage!, nil, nil, nil)
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreBtn(_ sender: Any) {
        if moreStackView.isHidden {
            moreStackView.isHidden = false
        }else{
            moreStackView.isHidden = true
        }
    }

// 編輯
    @IBAction func edit(_ sender: Any) {
        textViewPlaceholderLabel.isHidden = true
        titleField.isHidden = false
        textView.isEditable = true
        titleField.text = titleLabel.text
        phoneField.isHidden = false
        dialOutlet.isHidden = true
        phoneField.text = appMain.appPhone
        addressField.isHidden = false
        gotoMapOutlet.isHidden = true
        addressField.text = appMain.appAddress
    }

// 儲存按鈕，同時能執行 insert 和 update
    @IBAction func save(_ sender: Any) {
        
        if appMain.appnid == nil {    // Insert
            
            if titleField.text == "" || titleField.text == nil {
                titleLabel.text = dateLabel.text
            }else{
                titleLabel.text = titleField.text
            }
            
            let title = titleLabel.text
            let phone = phoneField.text
            let address = addressField.text
            let contents = textView.text
            let dateStr = dateLabel.text
            
            let sql = "INSERT INTO notes (title, phone, address, contents, notesDate) VALUES ('\(title!)', '\(phone!)', '\(address!)', '\(contents!)', '\(dateStr!)')"
            var point:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(appMain.db, sql, -1, &point, nil) == SQLITE_OK {
                if sqlite3_step(point) == SQLITE_DONE {
                    print("Insert OK")
                }else{
                    print("Insert Fail")
                }
            }
            
            let alert = UIAlertController(title: "儲存成功", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            titleField.isHidden = true
            textView.isEditable = false
            moreStackView.isHidden = true
            
// 重新從資料庫撈nid，給appnid設值，再儲存時才會進入update
            let newtitle = titleLabel.text
            let getIDsql = "SELECT nid FROM notes WHERE title = '\(newtitle!)'"
            
            if sqlite3_prepare(appMain.db, getIDsql, -1, &point, nil) == SQLITE_OK {
                
            }
            
            if sqlite3_step(point) == SQLITE_ROW {
                appMain.appnid = String(cString:sqlite3_column_text(point, 0))
            }

        // 修改資料
        }else{
            titleField.isHidden = true
            let nid = appMain.appnid
            if titleField.text == nil || titleField.text == "" {
                titleLabel.text = dateLabel.text
            }else{
                titleLabel.text = titleField.text
            }
            
            let title = titleLabel.text
            let phone = phoneField.text
            let address = addressField.text
            let contents = textView.text
            let sql = "UPDATE notes SET title = '\(title!)', phone = '\(phone!)', address = '\(address!)', contents = '\(contents!)' WHERE nid = '\(nid!)';"

            var point:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(appMain.db, sql, -1, &point, nil) == SQLITE_OK {
                if sqlite3_step(point) == SQLITE_DONE {
                    print("Update OK")
                }else{
                    print("Update Fail")
                }
            }
            let alert = UIAlertController(title: "修改成功", message:
                nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            moreStackView.isHidden = true
        }
        
    }
// 刪除檔案
    @IBAction func deleteBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "確定刪除此記事本?", message:
            nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {(action) -> Void in
        
            self.delNotes()
            
            // 清除 AppDelegate 儲存的變數
            self.appMain.appnid = nil
            self.appMain.appTitle = nil
            self.appMain.appContents = nil
            self.appMain.appDate = nil
            
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        moreStackView.isHidden = true
    }
    
    func delNotes(){
        let title = titleLabel.text
        let sql = "DELETE FROM notes WHERE title = '\(title!)'"
        
        var point:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(appMain.db, sql, -1, &point, nil) == SQLITE_OK {
            if sqlite3_step(point) == SQLITE_DONE {
                print("Delete OK")
            }else{
                print("Delete Fail")
            }
        }
    }
// 取得系統時間
    func showDate(){
        let currentdate = Date()
        let dateformatter = DateFormatter()
        //dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateformatter.dateFormat = "YYYY-MM-dd"
        let dateStr = dateformatter.string(from: currentdate)
        dateLabel.text = dateStr
    }
// 鍵盤
    func keyboardChange(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide{
            textView.contentInset = UIEdgeInsets.zero
        }else{
            textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardEndFrame.height + 10, 0)
            
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
        
    }
    func closeKeyboard() {
        view.endEditing(true)
    }
// 事件第一回應者
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.textView.resignFirstResponder()
        self.titleField.resignFirstResponder()
    }
// 背景
    @IBAction func backgroundYellow(_ sender: Any) {
        textView.backgroundColor = UIColor.yellow
    }
// 字體大小
    @IBAction func fontSize(_ sender: Any) {
        let alertView = UIAlertController(
            title: "預設字體大小",
            message:"\n\n\n\n\n\n\n\n\n",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 270, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // comment this line to use white color
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let setFontStr = Int(self.fontSizeList[pickerView.selectedRow(inComponent: 0)])
            let setFont = CGFloat(setFontStr!)
            self.textView.font = UIFont(name: "Helvetica-Light", size: setFont)
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: { _ in
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    
    @IBAction func gotoMapBtn(_ sender: Any) {
        if let mapPage = storyboard?.instantiateViewController(withIdentifier: "mapPage"){
            show(mapPage, sender: self)
        }
    }
    @IBOutlet weak var gotoMapOutlet: UIButton!
    
    @IBAction func dial(_ sender: Any) {
        
    }
    @IBOutlet weak var dialOutlet: UIButton!
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.textView.delegate = self
        
        moreStackView.isHidden = true
        
// 若是從 cell 來，先將資料庫的值，貼回去
        if appMain.appnid != nil {
            textViewPlaceholderLabel.isHidden = true
            titleLabel.text = appMain.appTitle
            
            let dialNumber = appMain.appPhone
            dialOutlet.setTitle(dialNumber, for: .normal)
            dialOutlet.contentHorizontalAlignment = .left
            phoneField.isHidden = true
            
            let address: String = appMain.appAddress!
            addressField.isHidden = true
            gotoMapOutlet.setTitle(address, for: .normal)
            gotoMapOutlet.contentHorizontalAlignment = .left
            
            textView.text = appMain.appContents
            dateLabel.text = appMain.appDate
            titleField.isHidden = true
            textView.isEditable = false
        }else{
            showDate()
        }
// 鍵盤 hide
        NotificationCenter.default.addObserver(self, selector: #selector(TextViewController.keyboardChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TextViewController.keyboardChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
// 做Toolbar 和 button
        let mytb = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        closeKeyboardBtn = UIButton(type: UIButtonType.system)
        closeKeyboardBtn?.frame = CGRect(x: 120, y: 0, width: 130, height: 40)
        closeKeyboardBtn?.backgroundColor = UIColor.lightGray
        closeKeyboardBtn?.setTitle("Close Keyboard", for: UIControlState.normal)
        closeKeyboardBtn?.addTarget(self, action: #selector(closeKeyboard), for: UIControlEvents.touchUpInside)
        mytb.addSubview(closeKeyboardBtn!)
        textView.inputAccessoryView = mytb
        self.textView.delegate = self
        titleField.inputAccessoryView = mytb
        self.titleField.delegate = self
        
        
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
