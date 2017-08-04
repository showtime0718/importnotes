//
//  drawVC.swift
//  Mynote
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 swift006. All rights reserved.
//

import UIKit

class drawVC: UIViewController {
    
    
    @IBAction func OK(_ sender: Any) {
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = 128
                break
                
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
       
    }
    
    let app = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var colorpick: UIView!
    var vc1controller : TextViewController?
   
    @IBOutlet weak var drawwing: drawwingVC!
    
    
    
    
    @IBAction func savedraw(_ sender: Any) {
      let drawimg = drawwing.takeSnapshotOfView(view: drawwing)
        //app.img = drawimg
        self.vc1controller?.vc2image = drawimg
        print(self)

    }
       @IBAction func cleardraw(_ sender: Any) {
        drawwing.clear()
    }
    @IBAction func colorcontrol(_ sender: Any) {
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = -10
                break
                
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    @IBAction func redColor(_ sender: Any) {
        app.color = UIColor.red
    
    }
    @IBAction func blackColor(_ sender: Any) {
        app.color = UIColor.black
    }
    
    @IBAction func greenColor(_ sender: Any) {
        app.color = UIColor.green
    }
    
    @IBAction func yellowColor(_ sender: Any) {
        app.color = UIColor.yellow
    }
    @IBAction func purpleColor(_ sender: Any) {
        app.color = UIColor.purple
    }
    @IBAction func blueColor(_ sender: Any) {
        app.color = UIColor.blue
    }
    
    @IBAction func erase(_ sender: Any) {
        drawwing.undo()
    }
    
       @IBAction func fontsize(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        

        
                // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(colorpick)
        colorpick.translatesAutoresizingMaskIntoConstraints = false
        colorpick.heightAnchor.constraint(equalToConstant: 128).isActive = true
        colorpick.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        colorpick.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c = colorpick.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 128)
        c.identifier = "bottom"
        c.isActive = true
        colorpick.layer.cornerRadius = 10
        
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
