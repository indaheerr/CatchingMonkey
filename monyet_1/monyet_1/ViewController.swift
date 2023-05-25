//
//  ViewController.swift
//  monyet_1
//
//  Created by Indah Rahmawati on 18/05/23.
//
import UIKit
import RealityKit
import Combine




class ViewController: UIViewController {

    var textPopUP = UILabel()
    @IBOutlet var arView: ARView!
//    var arView: ARView!
    
    var countBG: UIImageView!
    var poin: Int = 0
    var rotationTimers: [Timer] = []
    var movementTimers: [Timer] = []
    var spawnTimer: Timer?
    var cancellable: AnyCancellable? = nil
    let anchor = AnchorEntity(plane: .any, minimumBounds: [0.2,0.2])
    var gameTimer: Timer?
    var countingLabel = UILabel()
    var countdownLabel = UILabel()
    var gameTimer2: Timer?
    var countdownLabel2 = UILabel()
    var countTimeLabel2 = UILabel()
    var countingLabelCount = UILabel()
    var timeCount: Timer?
    var minutes: Int = 5
    var minutesFloat: Float = 0
    var textPoPUPCount = UILabel()
    
    var counterFix :String = ""
    var seconds = 60

    //LiGothicMed
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
       
        
        arView.scene.addAnchor(anchor)
        
        spawnEntities()

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.spawnEntities()
        }
        let darkBG = UIImageView(frame: UIScreen.main.bounds)
        darkBG.image = UIImage(named: "darkerBG")
        darkBG.contentMode =  .scaleAspectFill
        darkBG.alpha = 0.7
//        self.view.insertSubview(darkBG, at: 0)
        monkeysCountView()
        countingLabel.textColor = UIColor(hexString: "7C421E")
        startGameTimer()
//        self.view.insertSubview(darkBG, at: 0)
    }
    
    func spawnEntities() {
        var cards: [Entity] = []
            let box = MeshResource.generateBox(width: 0.1, height: 0.04, depth: 0.1)
            let material = SimpleMaterial(color: UIColor.red.withAlphaComponent(0), isMetallic: false)
            let model = ModelEntity(mesh:box, materials: [material])
            
            model.generateCollisionShapes(recursive: true)
            cards.append(model)
            for (index, card) in cards.enumerated() {
                let x = Float.random(in: -20...20)
                let z = Float.random(in: -20...20)
                card.position = [x*0.1, 0.1, z*0.1]
                anchor.addChild(card)
            }
            cancellable = ModelEntity.loadModelAsync(named: "Chimp")
            .collect()
            .sink(receiveCompletion: {error in
                print("Error: \(error)")
                self.cancellable?.cancel()
            }, receiveValue: { entities in
                var objects: [ModelEntity] = []
                for entity in entities {
                    entity.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: self.anchor)
                    entity.generateCollisionShapes(recursive: true)
//                    for _ in 1...2 {
                        let clonedEntity = entity.clone(recursive: true)
                        objects.append(clonedEntity)
                        
                        let rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                            var transform = clonedEntity.transform
                            transform.rotation *= simd_quatf(angle: 0.05, axis: [0, 0, 1])
                            clonedEntity.move(to: transform, relativeTo: clonedEntity.parent, duration: 0.01)
                        }
                        self.rotationTimers.append(rotationTimer)
                    entity.model?.materials = [SimpleMaterial(color: .brown, isMetallic: true)]
                }
                objects.shuffle()
                
                for (index, object) in objects.enumerated() {
                    cards[index].addChild(object)
                }
            })
        gameTimer = Timer.scheduledTimer(withTimeInterval: 200.0, repeats: false) { [weak self] timer in
            // Stop the game here
            self?.terminateGame()
        }
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        if let card = arView.entity(at: tapLocation) {
            var flipUpTransform = card.transform
            var randomAngle = Float.random(in: 0..<181)
            flipUpTransform.rotation = simd_quatf(angle: randomAngle, axis: [1,0,0])
            card.move(to: flipUpTransform, relativeTo: card, duration: 0.5, timingFunction: .easeInOut)
            poin += 1
            countingLabel.textColor = UIColor(hexString: "7C421E")
//            countingLabel.textColor = .black
            countingLabelCount.text = "monkeys catched: \(poin)"
            print("total catched monkey = \(poin)")
//            card.removeFromParent()

                        
            
        }
    }
    
    func monkeysCountView() {
        countBG = UIImageView(frame: CGRect(x: self.view.bounds.width - 180, y: 50, width: 166, height: 47))
        countBG.image = UIImage(named: "catchedBG")
        countBG.contentMode = .scaleAspectFit
        self.view.addSubview(countBG)

        countingLabelCount.frame = CGRect(x: self.view.bounds.width - 205, y: 45, width: 180, height: 50)
        countingLabelCount.text = "monkeys catched: \(poin)"
        countingLabelCount.font = UIFont.boldSystemFont(ofSize: 14)
//        countingLabel.font = UIFont(name: "Apple LiGothic", size: 10)
        countingLabelCount.textColor = UIColor(hexString: "#7C421E")
        countingLabelCount.textAlignment = .right
        self.view.addSubview(countingLabelCount)
    }

    
    func startGameTimer() {
        
        var timersBG: UIImageView!
        timersBG = UIImageView(frame: CGRect(x: self.view.bounds.width - 380, y: 50, width: 166, height: 47))
        timersBG.image = UIImage(named: "catchedBG")
        timersBG.contentMode = .scaleAspectFit
        self.view.addSubview(timersBG)
        countTimeLabel2.frame = CGRect(x: 45, y: 55, width: 100, height: 30)
        countTimeLabel2.textColor = UIColor.black
        countTimeLabel2.font = UIFont.boldSystemFont(ofSize: 14)
        countTimeLabel2.textAlignment = .left
        self.view.addSubview(countTimeLabel2)

//        countTimeLabel2.font = UIFont(name: "LiGothicMed", size: 16) // put here the correct font name
        countTimeLabel2.textColor = UIColor(hexString: "#7C421E")
        
        // Memulai timer
        timeCount = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.seconds -= 1
//            self.countTimeLabel2.text = "times: \(seconds)"
            
            self.minutesFloat = Float(self.seconds)/60
            self.minutes = Int(self.minutesFloat.rounded(.down))
//            print(self.minutes)
            var secondsModulus = self.seconds%60
            if secondsModulus >= 10 {
                print("\(self.minutes):\(secondsModulus)")
//                    self.countTimeLabel2.text = "\(self.minutes):\(secondsModulus)"
                self.counterFix = "\(self.minutes):\(secondsModulus)"
            }
            else {
                print("\(self.minutes):0\(secondsModulus)")
//                    self.countTimeLabel2.text = "\(self.minutes):0\(secondsModulus)"
                self.counterFix = "\(self.minutes):0\(secondsModulus)"
            }
            self.countTimeLabel2.text = "Time left: \(self.counterFix)"
            
            if self.seconds <= 0 {
                self.terminateGame()
            }
        }
    }

    func popUpEndGameCollect() {
        
        let darkBG = UIImageView(frame: UIScreen.main.bounds)
        darkBG.image = UIImage(named: "darkerBG")
        darkBG.contentMode =  .scaleAspectFill
        darkBG.alpha = 0.7
        view.addSubview(darkBG)

        
        var popUpCollect: UIImageView!
        popUpCollect = UIImageView(frame: CGRect(x: 34, y: 291, width: 325, height: 233))
        popUpCollect.image = UIImage(named: "popUp")
        popUpCollect.contentMode = .scaleAspectFit
        view.addSubview(popUpCollect)
        textPopUP.numberOfLines = 0
        textPopUP.lineBreakMode = .byWordWrapping
        textPopUP.text = "You have catch\n\n\nmonkeys!!"
        textPopUP.textColor = UIColor(hexString: "#7C421E")
        textPopUP.font = UIFont.boldSystemFont(ofSize: 28)
//        textPopUP.font = UIFont(name: "LiGothicMed", size: 28)
        textPopUP.textAlignment = .center
        textPopUP.frame = CGRect(x: 34, y: 291, width: 325, height: 233)
        
        textPoPUPCount.numberOfLines = 0
        textPoPUPCount.lineBreakMode = .byWordWrapping
        textPoPUPCount.text = "\(poin)"
        textPoPUPCount.textColor = UIColor(hexString: "#7C421E")
        textPoPUPCount.font = UIFont.boldSystemFont(ofSize: 40)
        textPoPUPCount.textAlignment = .center
        textPoPUPCount.frame = CGRect(x: 34, y: 291, width: 325, height: 233)

        let button = UIButton(type: .system) // adjust button type as needed
        button.setBackgroundImage(UIImage(named: "popUpButton"), for: .normal)
        button.frame = CGRect(x: 100, y: 490, width: 189, height: 66) // adjust frame as needed
//            button.setTitle("Play Again", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let buttonLabel = UILabel(frame: CGRect(x: 142, y: 490, width: 189, height: 66))
        buttonLabel.font = UIFont.boldSystemFont(ofSize: 22)
        buttonLabel.textColor = UIColor(hexString: "#F9D8C5")
        buttonLabel.text = "Play Again"


        view.addSubview(button)
        view.addSubview(textPopUP)
        view.addSubview(textPoPUPCount)
        view.addSubview(buttonLabel)
        
        
    }
    
//    func popUpCollectMonkey() {
//        let darkBG = UIImageView(frame: UIScreen.main.bounds)
//        darkBG.image = UIImage(named: "darkBG")
//        darkBG.contentMode =  .scaleAspectFill
//        darkBG.alpha = 0.5
//        view.addSubview(darkBG)
//
//        var popUpCollect: UIImageView!
//        popUpCollect = UIImageView(frame: CGRect(x: 34, y: 291, width: 325, height: 233))
//        popUpCollect.image = UIImage(named: "popUp")
//        popUpCollect.contentMode = .scaleAspectFit
//        view.addSubview(popUpCollect)
//
//        textPopUP.text = "You Have Catch \(poin) monkeys!!"
//        textPopUP.textColor = UIColor.white
//        textPopUP.font = UIFont.systemFont(ofSize: 36)
//        textPopUP.textAlignment = .center
//        textPopUP.frame = CGRect(x: 34, y: 291, width: 325, height: 233)
//
//        let button = UIButton(type: .system) // adjust button type as needed
//        button.setBackgroundImage(UIImage(named: "popUpButton"), for: .normal)
//        button.frame = CGRect(x: 125, y: 480, width: 189, height: 66) // adjust frame as needed
//        button.setTitle("Play Again", for: .normal)
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//
//
//        view.addSubview(button)
//        view.addSubview(textPopUP)
//    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func terminateGame() {
            // Invalidate all timers
            spawnTimer?.invalidate()
            rotationTimers.forEach { $0.invalidate() }
            movementTimers.forEach { $0.invalidate() }
            timeCount?.invalidate()
        
            
//            arView.scene.anchors.removeAll()

        popUpEndGameCollect()

        }
}



    

