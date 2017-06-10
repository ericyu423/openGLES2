/*Inside appDelegate didFinishLaunchingWithOptions
 window = UIWindow(frame: UIScreen.main.bounds)
 window?.rootViewController = ViewController()
 window?.makeKeyAndVisible()
 */

import UIKit
import GLKit



class ViewController: GLKViewController  {
    var curRed: Float = 0
    var increasing: Bool = true
    lazy var glkView: GLKView = {
        var glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        return glkView
    }()
    
   // let flashSprite = FlashSprite()
    
    let squareSprite = SquareSprite()

    override func viewDidLoad() {
        super.viewDidLoad()
        EAGLContext.setCurrent(glkView.context)
        //without this glkView doen't get called
 
    }
    func update(){
        if (increasing) {
            curRed += Float(1.0 * self.timeSinceLastUpdate)
        } else {
            curRed -= Float(1.0 * self.timeSinceLastUpdate)
        }
        if (curRed >= 1.0) {
            curRed = 1.0
            increasing = false
        }
        if (curRed <= 0.0) {
            curRed = 0.0;
            increasing = true
        }
        //flashSprite.red = curRed
        squareSprite.setupVBO()
        squareSprite.timeSinceLastUpdate = self.timeSinceLastUpdate
        squareSprite.setDefaultShaders()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        //flashSprite.draw()
       
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
         squareSprite.draw()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
        NSLog("timeSinceLastDraw: %f", self.timeSinceLastDraw);
        NSLog("timeSinceFirstResume: %f", self.timeSinceFirstResume);
        NSLog("timeSinceLastResume: %f", self.timeSinceLastResume);
        //interesting calls that time you about othe time inside view controller
          self.isPaused = !self.isPaused
        //isPaused pause both glkView and update (render loop)
    }

}

