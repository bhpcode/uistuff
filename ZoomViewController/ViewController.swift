//
//  ViewController.swift
//  ZoomViewController
//
//  Created by Matthew Connor on 24/08/2016.
//  Copyright © 2016 Matthew Connor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var showDetailAnimateController : ZoomController = ZoomController()
    var dismissDetailAnimateController : ZoomController = ZoomController()
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var testButton2: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        testButton.layer.masksToBounds = true
        testButton.layer.cornerRadius = 6;
        testButton.layer.borderWidth = 2
        testButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        testButton2.layer.masksToBounds = true
        testButton2.layer.cornerRadius = 6;
        testButton2.layer.borderWidth = 2
        testButton2.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func testButtonClicked(sender: AnyObject)
    {
        self.performSegueWithIdentifier("showDetailSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "showDetailSegue"){
            
            if let detailVC = segue.destinationViewController as? DetailViewController, senderView = sender as? UIView {
        
                let viewFrameInSuperview = self.view.convertRect(senderView.frame, toView: self.view)
                
                self.showDetailAnimateController.setupForZoomIn(viewFrameInSuperview, zoomView: self.view, transitionDuration: 0.7)
                
                self.dismissDetailAnimateController.setupForZoomOut(viewFrameInSuperview, transitionDuration: 0.7)
                self.dismissDetailAnimateController.zoomView = nil
                self.dismissDetailAnimateController.zoomFrame = viewFrameInSuperview
                self.dismissDetailAnimateController.zoomDirection = .ZoomOut
                self.dismissDetailAnimateController.transitionDuration = 0.7
                
                detailVC.transitioningDelegate = self
            }
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return self.showDetailAnimateController
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        return self.dismissDetailAnimateController
    }
    
 }

