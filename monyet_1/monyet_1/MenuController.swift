//
//  MenuController.swift
//  monyet_1
//
//  Created by Indah Rahmawati on 23/05/23.
//

//
//  ViewController.swift
//  monyet_1
//
//  Created by Indah Rahmawati on 18/05/23.
//
import UIKit
import RealityKit
import Combine




class MenuController: UIViewController {

    @IBAction func clickchase(_ sender: Any) {
        
        let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "arview1") as! MonyetfixController
            self.navigationController?.pushViewController(loginPageView, animated: true)
    }
    
    @IBAction func clickcollect(_ sender: Any) {
        print("coba")
        let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "arview") as! ViewController
            self.navigationController?.pushViewController(loginPageView, animated: true)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    

}

