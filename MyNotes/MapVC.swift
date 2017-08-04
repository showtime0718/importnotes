//
//  MapVC.swift
//  MyNotes
//
//  Created by li on 2017/7/29.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GMSServices.provideAPIKey("AIzaSyCsiWA63uHMtnJ9NbG8oBl13R1ahcBrHH4")
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.621262, longitude: -122.378945, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
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
