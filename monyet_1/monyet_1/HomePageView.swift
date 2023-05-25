//
//  HomePageView.swift
//  monyet_1
//
//  Created by Indah Rahmawati on 21/05/23.
//

import Foundation
import UIKit

class HomePageView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundCM")
        backgroundImage.contentMode =  .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let buttonChase = UIButton(type: .system) // adjust button type as needed
        buttonChase.setBackgroundImage(UIImage(named: "button1"), for: .normal)
        buttonChase.frame = CGRect(x: 72, y: 660, width: 265, height: 85)
        let buttonChaseLabel = UILabel(frame: CGRect(x: 108, y: 660, width: 265, height: 85))
        buttonChaseLabel.font = UIFont.boldSystemFont(ofSize: 22)
        buttonChaseLabel.textColor = UIColor(ciColor: .white)
        buttonChaseLabel.text = "Chase The Monkey!"
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        view.addSubview(buttonChase)
        view.addSubview(buttonChaseLabel)
        
        let buttonCollect = UIButton(type: .system) // adjust button type as needed
        buttonCollect.setBackgroundImage(UIImage(named: "button1"), for: .normal)
        buttonCollect.frame = CGRect(x: 72, y: 530, width: 265, height: 85)
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let buttonCollectLabel = UILabel(frame: CGRect(x: 105, y: 530, width: 265, height: 85))
        buttonCollectLabel.font = UIFont.boldSystemFont(ofSize: 22)
        buttonCollectLabel.textColor = UIColor(ciColor: .white)
        buttonCollectLabel.text = "Collect The Monkey!"
        view.addSubview(buttonCollect)
        view.addSubview(buttonCollectLabel)
    }
    
    @objc func buttonTapped() {
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
        print("Button was tapped!")
    }
    

}

