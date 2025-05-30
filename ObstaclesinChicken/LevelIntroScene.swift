import SpriteKit

class LevelIntroScene: SKScene {
    let level: Int
    private var startButton: SKSpriteNode!

    init(level: Int, size: CGSize) {
        self.level = level
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "levelIntroBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = size
        addChild(background)

        startButton = SKSpriteNode(imageNamed: "jumpButtonImage")
        startButton.name = "start"
        startButton.position = CGPoint(x: size.width/2, y: size.height * 0.15)
        startButton.zPosition = 2
        addChild(startButton)
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node == startButton {
            let pressDown = SKAction.scale(to: 0.9, duration: 0.1)
            startButton.run(pressDown)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node == startButton {
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            let transition = SKAction.run {
                let road = RoadScene(level: self.level, isReturning: false, size: self.size)
                road.scaleMode = .aspectFill
                self.view?.presentScene(road, transition: .fade(withDuration: 1))
            }
            let sequence = SKAction.sequence([scaleUp, transition])
            startButton.run(sequence)
        } else {
            startButton.run(SKAction.scale(to: 1.0, duration: 0.1))
        }
    }
}
