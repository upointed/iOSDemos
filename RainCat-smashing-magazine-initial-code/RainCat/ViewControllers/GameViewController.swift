//
//  GameViewController.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import SpriteKit
//import GameplayKit

extension GameViewController: GameSceneDelegate {
    func moveEnd() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let sceneNode = GameScene(size: view.frame.size)
    sceneNode.interactionDelegate = self;

    if let view = self.view as! SKView? {
          view.presentScene(sceneNode)
          view.ignoresSiblingOrder = true
          view.showsPhysics = true
          view.showsFPS = true
          view.showsNodeCount = true
    }
  }
    

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
