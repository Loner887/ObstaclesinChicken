import SpriteKit
import GameplayKit

class EggGameScene: SKScene {
    let chicken = SKSpriteNode(imageNamed: "chickenGameImage")
    static var collectedEggs = 0
    let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    let levelLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    var level: Int = 1

    init(level: Int, size: CGSize) {
        self.level = level
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func didMove(to view: SKView) {
        EggGameScene.collectedEggs = 0
        setupBackground()
        setupChicken()
        setupUI()
        startEggDrop()
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "gameBackgroundImage")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    func setupChicken() {
        chicken.position = CGPoint(x: size.width/2, y: 100)
        addChild(chicken)
    }

    func setupUI() {
        let scoreBG = SKSpriteNode(imageNamed: "scoreBackground")
        scoreBG.position = CGPoint(x: size.width * 0.25, y: size.height * 0.9)
        addChild(scoreBG)

        scoreLabel.text = "0/50"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: scoreBG.position.x + 20, y: scoreBG.position.y - 8) 
        scoreLabel.zPosition = 2
        addChild(scoreLabel)

        let levelBG = SKSpriteNode(imageNamed: "levelBackground")
        levelBG.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        addChild(levelBG)

        levelLabel.text = "Level \(level)"
        levelLabel.fontSize = 30
        levelLabel.fontColor = .black
        levelLabel.position = CGPoint(x: levelBG.position.x, y: levelBG.position.y - 8)
        levelLabel.zPosition = 2
        addChild(levelLabel)
    }

    func startEggDrop() {
        let spawn = SKAction.run { [weak self] in self?.dropEgg() }
        let wait = SKAction.wait(forDuration: 0.8)
        run(.repeatForever(.sequence([spawn, wait])))
    }

    func dropEgg() {
        let egg = SKSpriteNode(imageNamed: "egg")
        let x = CGFloat.random(in: 50...(size.width - 50))
        egg.position = CGPoint(x: x, y: size.height + 50)
        egg.name = "egg"
        addChild(egg)
        egg.run(.sequence([
            .moveTo(y: -100, duration: 3.0),
            .removeFromParent()
        ]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let x = touch.location(in: self).x
        let moveX: CGFloat = x < size.width/2 ? -50 : 50
        let newX = chicken.position.x + moveX
        if newX > 0 && newX < size.width {
            chicken.run(.moveTo(x: newX, duration: 0.2))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "egg") { egg, _ in
            if egg.frame.intersects(self.chicken.frame) {
                EggGameScene.collectedEggs += 1
                self.scoreLabel.text = "\(EggGameScene.collectedEggs)/50"
                egg.removeFromParent()
                if EggGameScene.collectedEggs >= 50 {
                    self.returnThroughRoad()
                }
            }
        }
    }

    private func returnThroughRoad() {
        let roadScene = RoadScene(level: level, isReturning: true, size: size)
        roadScene.scaleMode = .aspectFill
        view?.presentScene(roadScene, transition: .fade(withDuration: 1))
    }
}
