import SpriteKit

class WinScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupButtons()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "winBackgroundImage")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupButtons() {

        let homeButton = SKSpriteNode(imageNamed: "homeButtonImage")
        homeButton.name = "home"
        homeButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        homeButton.zPosition = 1
        homeButton.setScale(0.9)
        addChild(homeButton)
        
        let restartButton = SKSpriteNode(imageNamed: "restartButtonImage")
        restartButton.name = "restart"
        restartButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        restartButton.zPosition = 1
        restartButton.setScale(0.9)
        addChild(restartButton)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node.name == "restart" {
            let gameScene = LevelIntroScene(level: 1, size: size) 
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: .fade(withDuration: 1))
        } else if node.name == "home" {
            let startScene = StartScene(size: size)
            startScene.scaleMode = .aspectFill
            view?.presentScene(startScene, transition: .fade(withDuration: 1))
        }
    }
}
