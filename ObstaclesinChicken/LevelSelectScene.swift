import SpriteKit

class LevelSelectScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLevelButtons()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "levelSelectBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupLevelButtons() {
        let buttonSize = CGSize(width: 122, height: 122)
        let spacing: CGFloat = 20

        let columns = 2
        let rows = 3

        let totalWidth = CGFloat(columns) * buttonSize.width + CGFloat(columns - 1) * spacing
        let totalHeight = CGFloat(rows) * buttonSize.height + CGFloat(rows - 1) * spacing

        let startX = (size.width - totalWidth) / 2 + buttonSize.width / 2
        let startY = (size.height + totalHeight) / 2 - buttonSize.height / 2 + 100

        for i in 0..<6 {
            let levelNumber = i + 1
            let column = i % columns
            let row = i / columns

            let x = startX + CGFloat(column) * (buttonSize.width + spacing)
            let y = startY - CGFloat(row) * (buttonSize.height + spacing)

            let button = SKSpriteNode(imageNamed: "levelButton\(levelNumber)")
            button.name = "level\(levelNumber)"
            button.size = buttonSize
            button.position = CGPoint(x: x, y: y)
            button.zPosition = 1
            addChild(button)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if let name = node.name, name.starts(with: "level") {
            if let levelNumber = Int(name.replacingOccurrences(of: "level", with: "")) {
                let gameScene = LevelIntroScene(level: levelNumber, size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: .fade(withDuration: 1))
            }
        }
    }
}
