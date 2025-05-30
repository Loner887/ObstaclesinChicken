import SpriteKit

class StartScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupButtons()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "menuBackgroundImage")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = size
        addChild(background)
    }
    
    private func setupButtons() {
        let playButton = SKSpriteNode(imageNamed: "playButtonImage")
        playButton.name = "playButton"
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        playButton.zPosition = 3
        addChild(playButton)
        
        let levelButton = SKSpriteNode(imageNamed: "levelButtonImage")
        levelButton.name = "levelButton"
        levelButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        levelButton.zPosition = 2
        addChild(levelButton)
        
        let settingsButton = SKSpriteNode(imageNamed: "settingsButtonImage")
        settingsButton.name = "settingsButton"
        settingsButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        settingsButton.zPosition = 1
        addChild(settingsButton)
        
        let privacyButton = SKSpriteNode(imageNamed: "privacyButtonImage")
        privacyButton.name = "privacyButton"
        privacyButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        privacyButton.zPosition = 1
        addChild(privacyButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "playButton" {
            let levelScene = LevelSelectScene(size: size)
            levelScene.scaleMode = .aspectFill
            view?.presentScene(levelScene, transition: SKTransition.fade(withDuration: 1))
        } else if touchedNode.name == "levelButton" {
            let levelScene = LevelSelectScene(size: size)
            levelScene.scaleMode = .aspectFill
            view?.presentScene(levelScene, transition: SKTransition.fade(withDuration: 1))
        } else if touchedNode.name == "settingsButton" {
            let settingsScene = SettingsScene(size: size)
            settingsScene.scaleMode = .aspectFill
            view?.presentScene(settingsScene, transition: SKTransition.fade(withDuration: 1))
        } else if touchedNode.name == "privacyButton" {
            openPrivacyPolicy()
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/obstacles-in-chicken-privacy-policy/6d147405-0f30-4330-be20-e95873fd0cd7/privacy") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
