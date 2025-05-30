import SpriteKit

class RoadScene: SKScene {
    let chicken = SKSpriteNode(imageNamed: "chickenImage")
    var isReturning = false
    var level: Int = 1
    var carTimer: Timer?
    var scoreBeforeCollision: Int = 0
    
    init(level: Int = 1, isReturning: Bool = false, size: CGSize) {
        self.level = level
        self.isReturning = isReturning
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupChicken()
        spawnCars()
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "roadBackgroundImage")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }

    private func setupChicken() {
        chicken.position = isReturning
        ? CGPoint(x: size.width * 0.9, y: size.height / 2)
        : CGPoint(x: size.width * 0.1, y: size.height / 2)
        chicken.zPosition = 1
        addChild(chicken)
    }

    private func spawnCars() {
        let create = SKAction.run { [weak self] in self?.addCar() }
        let wait = SKAction.wait(forDuration: 1.2)
        run(.repeatForever(.sequence([create, wait])))
    }

    private func addCar() {
        let carImageName = Bool.random() ? "car1" : "car2"
        let car = SKSpriteNode(imageNamed: carImageName)
        let leftLaneX = size.width / 2 - 40
        let rightLaneX = size.width / 2 + 40
        let isGoingUp = Bool.random()
        car.position = CGPoint(
            x: isGoingUp ? leftLaneX : rightLaneX,
            y: isGoingUp ? -100 : size.height + 100
        )
        car.zRotation = isGoingUp ? 0 : .pi
        car.name = "car"
        car.zPosition = 0
        addChild(car)
        let moveY = isGoingUp ? size.height + 200 : -200
        let baseSpeed = max(1.0, 3.0 - Double(level) * 0.3)
        let duration = Double.random(in: baseSpeed...(baseSpeed + 0.5))
        car.run(.sequence([
            .moveTo(y: moveY, duration: duration),
            .removeFromParent()
        ]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let x = touch.location(in: self).x
        let moveX: CGFloat = x < size.width / 2 ? -50 : 50
        let newX = chicken.position.x + moveX

        if newX > 0 && newX < size.width {
            chicken.xScale = moveX > 0 ? abs(chicken.xScale) : -abs(chicken.xScale)
            chicken.run(.moveTo(x: newX, duration: 0.2))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "car") { car, _ in
            if car.frame.intersects(self.chicken.frame) {
                self.handleCollision()
            }
        }

        if !isReturning && chicken.position.x > size.width - 100 {
            self.startEggScene()
        } else if isReturning && chicken.position.x < 100 {
            self.completeLevel()
        }
    }

    private func handleCollision() {
        chicken.run(.shake(duration: 0.3))

        let wait = SKAction.wait(forDuration: 0.4)
        let transition = SKAction.run {
            self.view?.presentScene(StartScene(size: self.size), transition: .fade(withDuration: 1))
        }
        run(.sequence([wait, transition]))
    }


    private func startEggScene() {
        let eggScene = EggGameScene(level: level, size: size)
        eggScene.scaleMode = .aspectFill
        view?.presentScene(eggScene, transition: .fade(withDuration: 1))
    }

    private func completeLevel() {
        view?.presentScene(WinScene(size: size), transition: .fade(withDuration: 1))
    }
}

extension SKAction {
    static func shake(duration: CGFloat, amplitudeX: Int = 10, amplitudeY: Int = 6) -> SKAction {
        let numberOfShakes = Int(duration / 0.04)
        var actionsArray: [SKAction] = []

        for _ in 1...numberOfShakes {
            let dx = CGFloat(Int.random(in: -amplitudeX...amplitudeX))
            let dy = CGFloat(Int.random(in: -amplitudeY...amplitudeY))
            let shakeAction = SKAction.moveBy(x: dx, y: dy, duration: 0.02)
            shakeAction.timingMode = .easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }

        return SKAction.sequence(actionsArray)
    }
}
