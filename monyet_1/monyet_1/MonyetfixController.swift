
//  ViewController.swift
//  monyet_3
//
//  Created by Indah Rahmawati on 20/05/23.
//
import UIKit
import RealityKit
import Combine
import ARKit


class MonyetfixController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var arView: ARView!
    var poin : Int = 0
    var movementTimers: [Timer] = []
    var rotationTimers: [Timer] = []
    var textPopUP = UILabel()
    var popUpCollect: UIImageView!
    var countBG: UIImageView!
    var countTimeLabel2 = UILabel()
    var timeCount: Timer?
    
    var bottomLabel = UILabel()
    var textPoPUPCount = UILabel()
    var minutesFloat: Float = 0
    var minutes: Int = 0
    var counterFix :String = ""
    var gameTimes = 150
    var seconds = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let anchor = AnchorEntity(plane: .any, minimumBounds: [0.2,0.2])

//        let anchor = AnchorEntity(world: <#T##float4x4#>)
        arView.scene.addAnchor(anchor)

//            let box = MeshResource.generateBox(width: 0.1, height: 0.04, depth: 0.1)
//            let material = SimpleMaterial(color: .blue, isMetallic: true)
//            let model = ModelEntity(mesh:box, materials: [material])
//
//            model.generateCollisionShapes(recursive: true)
        buttonLabel()
        
//        -----------------------------------------------------------------------
        var timersBG: UIImageView!
        timersBG = UIImageView(frame: CGRect(x: 85, y: 60, width: 216, height: 53))
        timersBG.image = UIImage(named: "longTimersBG")
        timersBG.contentMode = .scaleAspectFit
        self.view.addSubview(timersBG)
        countTimeLabel2.frame = CGRect(x: 118, y: 60, width: 216, height: 53)
        countTimeLabel2.textColor = UIColor(hexString: "#7C421E")
        countTimeLabel2.font = UIFont.boldSystemFont(ofSize: 23)
        countTimeLabel2.textAlignment = .left
        self.view.addSubview(countTimeLabel2)
        
        
        
        

        
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
                self.popUpEndGameCatchFailed()
            }
        }
//        -------------------------------------------------------------------
        
        
        
        
        
        let box = MeshResource.generateBox(width: 0.1, height: 0.04, depth: 0.1)
//        let material = SimpleMaterial(color: .blue, isMetallic: false)
        
        let material = SimpleMaterial(color: UIColor.red.withAlphaComponent(0), isMetallic: false)
        let model = ModelEntity(mesh:box, materials: [material])
        
        
        model.generateCollisionShapes(recursive: true)

            let x = Float.random(in: -10...10)
            let z = Float.random(in: -10...10)
            model.position = [x*0.1, 0.1, z*0.1]
            anchor.addChild(model)

        
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(named: "chimpKing")
            .collect()
            .sink(receiveCompletion: {error in
                print("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: { entities in
                var objects: [ModelEntity] = []
                for entity in entities {
//                    entity.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: anchor)
                    entity.setScale(SIMD3<Float>(0.02, 0.02, 0.02), relativeTo: anchor)
                    entity.generateCollisionShapes(recursive: true)
                    for _ in 1...10 {
                        objects.append(entity.clone(recursive: true))
                    }
                }
                objects.shuffle()
//                let rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
//                    var transform = objects[0].transform
//                    transform.rotation *= simd_quatf(angle: 0.05, axis: [0, 0, 1])
//                    objects[0].move(to: transform, relativeTo: objects[0], duration: 0.01)
//                }
//                self.rotationTimers.append(rotationTimer)
                var monkey = objects[0]

                
                model.addChild(monkey)
                
                
//                let movementTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
//                    var transform = monkey.transform
//                    var movementX = Float.random(in: -4..<4)
//                    var movementZ = Float.random(in: -2..<2)
//                    transform.translation.z += Float(movementZ)
//                    transform.translation.x += Float(movementX)
//                    monkey.move(to: transform, relativeTo: monkey.parent, duration: 1)
//
//
//                    let objectPosition = monkey.transform.translation
//                    let cameraTransform = self.arView.cameraTransform
//                    let cameraPosition = cameraTransform.translation
//
//                    let dx = objectPosition.x - cameraPosition.x
//                    let dy = objectPosition.y - cameraPosition.y
//                    let dz = objectPosition.z - cameraPosition.z
//                    let distance = sqrt(dx*dx + dy*dy + dz*dz)
//                    if distance < 4 {
//                        print("distance = \(distance), CLICK THE MONKEY!")
//                        self.bottomLabel.text = "Catch The Monkey!!"
//                        self.bottomLabel.textColor = UIColor.red
//                    }
//                    else {
//                        print("distance = \(distance), CHASE THE MONKEY!")
//                        self.bottomLabel.text = "Chase The Monkey!!"
//                        self.bottomLabel.textColor = UIColor.black
//                    }
//
//
//                    self.detectMonkey(monkey: monkey)
//                }
//                self.movementTimers.append(movementTimer)
//
            })

        

    }
    
    
    func detectMonkey (monkey: ModelEntity?) {
        if let object = monkey, let anchor = arView.scene.anchors.first {
            // Mendapatkan transformasi objek dalam ruang dunia
            let objectWorldTransform = anchor.convert(transform: object.transform, to: nil)
            print("objectWorldTransform = \(objectWorldTransform)")
            
            // Mendapatkan posisi objek dalam ruang dunia
            let objectWorldPosition = SIMD3<Float>(objectWorldTransform.translation)
            print("objectWorldPosition = \(objectWorldPosition)")
            // Mengkonversi posisi objek ke dalam koordinat layar 2D
            
            let screenPosition = arView.project(objectWorldPosition)
            print("screenPosition = \(screenPosition)")
            // Mendapatkan ukuran layar
            let screenSize = UIScreen.main.bounds.size
            print("screenSize = \(screenSize)")
            
            // Mendapatkan ukuran layar dalam piksel per centimeter
            let screenScale = UIScreen.main.scale
            print("screenScale = \(screenScale)")
            let screenPPI = UIScreen.main.nativeScale * 163.0
            let pixelsPerCentimeter = screenPPI / 2.54
            
            // Menghitung ukuran objek dalam centimeter
            let objectSize = CGSize(width: screenPosition!.x / pixelsPerCentimeter,
                                    height: screenPosition!.y / pixelsPerCentimeter)
            print("objectWorldPosition x = \(objectWorldPosition.x)")
            print("objectWorldPosition y = \(objectWorldPosition.y)")
            print("screenPosition x = \(screenPosition!.x)")
            print("screenPosition y = \(screenPosition!.y)")
            
            print("Ukuran objek AR: \(objectSize)")
        }
    }
    

    
//    func detectObjectSize(monkey: ModelEntity?) {
//
//        if let object = monkey, let anchor = arView.scene.anchors.first {
//            // Mendapatkan transformasi objek dalam ruang dunia
//            let objectWorldTransform = anchor.convert(transform: object.transform, to: nil)
//
//            // Mendapatkan posisi objek dalam ruang dunia
//            let objectWorldPosition = SIMD3<Float>(objectWorldTransform.translation)
//
//            // Mengkonversi posisi objek ke dalam koordinat layar 2D
//            let screenPosition = arView.project(objectWorldPosition)
//
//            // Mendapatkan ukuran layar
//            let screenSize = UIScreen.main.bounds.size
//
//            // Mendapatkan ukuran layar dalam piksel per centimeter
//            let screenScale = UIScreen.main.scale
//            let screenPPI = UIScreen.main.nativeScale * 163.0
//            let pixelsPerCentimeter = screenPPI / 2.54
//
//            // Menghitung ukuran objek dalam centimeter
//            let objectSize = CGSize(width: screenPosition!.x / pixelsPerCentimeter,
//                                    height: screenPosition!.y / pixelsPerCentimeter)
//
//            print("Ukuran objek AR: \(objectSize)")
//        }
//    }
    
    
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        if let card = arView.entity(at: tapLocation) {
            let objectPosition = card.transform.translation
            let cameraTransform = self.arView.cameraTransform
            let cameraPosition = cameraTransform.translation
            
            let dx = objectPosition.x - cameraPosition.x
            let dy = objectPosition.y - cameraPosition.y
            let dz = objectPosition.z - cameraPosition.z
            let distance = sqrt(dx*dx + dy*dy + dz*dz)
            print("distance = \(distance)")
            if distance < 4 {
                print("distance = \(distance), CLICK THE MONKEY!")
                bottomLabel.text = "Catch The Monkey!!"
                bottomLabel.textColor = UIColor.red
                var flipUpTransform = card.transform
                var randomAngle = Float.random(in: 0..<181)
                flipUpTransform.rotation = simd_quatf(angle: randomAngle, axis: [1,0,0])
                card.move(to: flipUpTransform, relativeTo: card, duration: 0.5, timingFunction: .easeInOut)
                poin += 1
                card.removeFromParent()
                terminateGame()
                popUpCollectMonkey()
            }
            else {
                print("distance = \(distance), CHASE THE MONKEY!")
                bottomLabel.text = "Chase The Monkey!!"
                bottomLabel.textColor = UIColor.black
            }

            
            
        }
    }
    
    func terminateGame() {
        movementTimers.forEach { $0.invalidate() }
        timeCount?.invalidate()
        
        
    }
    
    func popUpCollectMonkey() {
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
//            var poin = 100

        var totalTimes = gameTimes - seconds
        var totalTimesFloat: Float = 0
        var totalTimesMinutes = 0
        var totalTimesString = ""
        totalTimesFloat = Float(totalTimes)/60
        totalTimesMinutes = Int(totalTimesFloat.rounded(.down))
//            print(self.minutes)
        var secondsModulus = totalTimes%60
        if secondsModulus >= 10 {
            print("\(totalTimesMinutes):\(secondsModulus)")
//                    self.countTimeLabel2.text = "\(self.minutes):\(secondsModulus)"
            totalTimesString = "\(totalTimesMinutes):\(secondsModulus)"
        }
        else {
            print("\(totalTimesMinutes):0\(secondsModulus)")
//                    self.countTimeLabel2.text = "\(self.minutes):0\(secondsModulus)"
            totalTimesString = "\(totalTimesMinutes):0\(secondsModulus)"
        }
        
//            textPopUP.text = "You Have Catch \(poin) monkeys!!"
        textPopUP.numberOfLines = 0
        textPopUP.lineBreakMode = .byWordWrapping
        textPopUP.text = "You Have Catch\nThe Monkey in\n\n\n"
        textPopUP.textColor = UIColor(hexString: "#7C421E")
        textPopUP.font = UIFont.boldSystemFont(ofSize: 28)
        textPopUP.textAlignment = .center
        textPopUP.frame = CGRect(x: 34, y: 291, width: 325, height: 233)
        
        textPoPUPCount.numberOfLines = 0
        textPoPUPCount.lineBreakMode = .byWordWrapping
        textPoPUPCount.text = "\n\(totalTimesString)!!"
        textPoPUPCount.textColor = UIColor(hexString: "#7C421E")
        textPoPUPCount.font = UIFont.boldSystemFont(ofSize: 40)
        textPoPUPCount.textAlignment = .center
        textPoPUPCount.frame = CGRect(x: 34, y: 291, width: 325, height: 233)

        let button = UIButton(type: .system) // adjust button type as needed
        button.setBackgroundImage(UIImage(named: "popUpButton"), for: .normal)
        button.frame = CGRect(x: 100, y: 490, width: 189, height: 66) // adjust frame as needed
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//            button.setTitle("Play Again", for: .normal)
//            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let buttonLabel = UILabel(frame: CGRect(x: 142, y: 490, width: 189, height: 66))
        buttonLabel.font = UIFont.boldSystemFont(ofSize: 22)
        buttonLabel.textColor = UIColor(hexString: "#F9D8C5")
        buttonLabel.text = "Play Again"


        view.addSubview(button)
        view.addSubview(textPopUP)
        view.addSubview(textPoPUPCount)
        view.addSubview(buttonLabel)
    }
    
 
    
    func buttonLabel() {
        bottomLabel.text = "Chase The Monkey!!"
//        buttonLabel.textColor = UIColor(hexString: "#7C421E")
        bottomLabel.frame = CGRect(x: 50, y: 730, width: 300, height: 33)
        bottomLabel.textColor = UIColor.black
        bottomLabel.font = UIFont.boldSystemFont(ofSize: 25)
        bottomLabel.textAlignment = .center
        self.view.addSubview(bottomLabel)
    }
    
//    func timers() {
//        var timersBG: UIImageView!
//        timersBG = UIImageView(frame: CGRect(x: 85, y: 60, width: 216, height: 53))
//        timersBG.image = UIImage(named: "longTimersBG")
//        timersBG.contentMode = .scaleAspectFit
//        self.view.addSubview(timersBG)
//        countTimeLabel2.frame = CGRect(x: 118, y: 60, width: 216, height: 53)
//        countTimeLabel2.textColor = UIColor(hexString: "#7C421E")
//        countTimeLabel2.font = UIFont.boldSystemFont(ofSize: 23)
//        countTimeLabel2.textAlignment = .left
//        self.view.addSubview(countTimeLabel2)
//
//
//        var seconds = 100
//
//
//
//        // Memulai timer
//        timeCount = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            seconds -= 1
////            self.countTimeLabel2.text = "times: \(seconds)"
//
//            self.minutesFloat = Float(seconds)/60
//            self.minutes = Int(self.minutesFloat.rounded(.down))
////            print(self.minutes)
//            var secondsModulus = seconds%60
//            if secondsModulus >= 10 {
//                print("\(self.minutes):\(secondsModulus)")
////                    self.countTimeLabel2.text = "\(self.minutes):\(secondsModulus)"
//                self.counterFix = "\(self.minutes):\(secondsModulus)"
//            }
//            else {
//                print("\(self.minutes):0\(secondsModulus)")
////                    self.countTimeLabel2.text = "\(self.minutes):0\(secondsModulus)"
//                self.counterFix = "\(self.minutes):0\(secondsModulus)"
//            }
//            self.countTimeLabel2.text = "Time left: \(self.counterFix)"
//
//            if seconds <= 0 {
//                self.terminateGame()
//            }
//        }
//    }
    func popUpEndGameCatchFailed() {
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
//        var time = seconds
        
        textPoPUPCount.numberOfLines = 0
        textPoPUPCount.lineBreakMode = .byWordWrapping
        textPoPUPCount.text = "LOSER!!"
        textPoPUPCount.textColor = UIColor(hexString: "#7C421E")
        textPoPUPCount.font = UIFont.boldSystemFont(ofSize: 40)
        textPoPUPCount.textAlignment = .center
        textPoPUPCount.frame = CGRect(x: 34, y: 250, width: 325, height: 233)
        
//            textPopUP.text = "You Have Catch \(poin) monkeys!!"
        textPopUP.numberOfLines = 0
        textPopUP.lineBreakMode = .byWordWrapping
        textPopUP.text = "\n\nYou failed to catch the monkey :P"
        textPopUP.textColor = UIColor(hexString: "#7C421E")
        textPopUP.font = UIFont.boldSystemFont(ofSize: 28)
        textPopUP.textAlignment = .center
        textPopUP.frame = CGRect(x: 44, y: 291, width: 305, height: 233)

        let button = UIButton(type: .system) // adjust button type as needed
        button.setBackgroundImage(UIImage(named: "popUpButton"), for: .normal)
        button.frame = CGRect(x: 100, y: 490, width: 189, height: 66) // adjust frame as needed
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//            button.setTitle("Play Again", for: .normal)
//            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let buttonLabel = UILabel(frame: CGRect(x: 142, y: 490, width: 189, height: 66))
        buttonLabel.font = UIFont.boldSystemFont(ofSize: 22)
        buttonLabel.textColor = UIColor(hexString: "#F9D8C5")
        buttonLabel.text = "Play Again"


        view.addSubview(button)
        view.addSubview(textPopUP)
        view.addSubview(textPoPUPCount)
        view.addSubview(buttonLabel)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
