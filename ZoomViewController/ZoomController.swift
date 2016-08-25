//
//  ZoomViewController.swift
//  ZoomViewController
//
//  Created by Matthew Connor on 24/08/2016.
//  Copyright © 2016 Matthew Connor. All rights reserved.
//

import UIKit

@objc public class ZoomController : NSObject, UIViewControllerAnimatedTransitioning
{
    public var zoomFrame : CGRect = CGRectZero
    public var zoomView : UIView? = nil
    public var transitionDuration : NSTimeInterval = 0.3
    public var zoomDirection : Direction = .ZoomIn
    
    static public var dbgDurationMultiplier : NSTimeInterval = 1.0
    
    public enum Direction {
        case ZoomIn
        case ZoomOut
    }
    
    class func setDebugDuration(tf : Bool)
    {
        dbgDurationMultiplier = tf ? 10.0 : 1.0
    }
    
    public func setupForZoomIn(zoomFrame: CGRect, zoomView: UIView?, transitionDuration : NSTimeInterval = 0.3)
    {
        self.zoomFrame = zoomFrame
        self.zoomView = zoomView
        self.transitionDuration = transitionDuration
        self.zoomDirection = .ZoomIn
    }
    
    public func setupForZoomOut(zoomFrame: CGRect, transitionDuration : NSTimeInterval = 0.3)
    {
        self.zoomFrame = zoomFrame
        self.zoomView = nil
        self.transitionDuration = transitionDuration
        self.zoomDirection = .ZoomOut
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return transitionDuration * ZoomController.dbgDurationMultiplier
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else { return }
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        guard let containerView = transitionContext.containerView() else { return }
        
        let duration = self.transitionDuration(transitionContext)
        
        if (self.zoomDirection == .ZoomIn) {
        
            guard let zoomView = self.zoomView else { return }
        
            let toSnapshotView = toVC.view.snapshotViewAfterScreenUpdates(true)
            let fromSnapshotView = zoomView.snapshotViewAfterScreenUpdates(true)
            
            let targetFrame = transitionContext.finalFrameForViewController(toVC)
            
            containerView.addSubview(fromSnapshotView)
            containerView.addSubview(toSnapshotView)
            containerView.addSubview(toVC.view)
            
            let zoomFrame = createZoomRect(self.zoomFrame, inRect: fromVC.view.frame)
            
            toSnapshotView.frame = self.zoomFrame
            toSnapshotView.alpha = 0.0
            toVC.view.alpha = 0.0
            
            UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: .CalculationModeLinear, animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 2.0/3.0, animations: {
                    fromSnapshotView.frame = zoomFrame;
                    toSnapshotView.frame = targetFrame;
                    toSnapshotView.alpha = 0.67;
                })
                
                UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: {
                    toVC.view.alpha = 1.0;
                })
                
                }) { (finished) in
                    fromSnapshotView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
        } else {
            
            let toSnapshotView = toVC.view.snapshotViewAfterScreenUpdates(true)
            let fromSnapshotView = fromVC.view.snapshotViewAfterScreenUpdates(true)
            fromSnapshotView.frame = fromVC.view.frame

            containerView.addSubview(toVC.view)
            containerView.addSubview(toSnapshotView)
            containerView.addSubview(fromSnapshotView)

            toVC.view.alpha = 1.0
            toSnapshotView.frame = createZoomRect(self.zoomFrame, inRect: toVC.view.frame)
            
            UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: .CalculationModeLinear, animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 2.0/3.0, animations: {
                    fromSnapshotView.frame = self.zoomFrame;
                    fromSnapshotView.alpha = 0.5
                    toSnapshotView.frame = toVC.view.frame
                })
                
                UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: {
                    toVC.view.alpha = 1.0
                    fromSnapshotView.alpha = 0.0
                })
                
            }) { (finished) in
                fromSnapshotView.removeFromSuperview()
                toSnapshotView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
            
        }
        
    }
    
    internal func createZoomRect(zoomArea : CGRect, inRect : CGRect) -> CGRect
    {
        NSLog("zoomArea=\(zoomArea) inRect=\(inRect)")
        
        let wR = inRect.size.width / zoomArea.size.width
        let hR = inRect.size.height / zoomArea.size.height;
        
        let tX = -wR * zoomArea.origin.x;
        let tY = -hR * zoomArea.origin.y;
        let tW = inRect.size.width * wR;
        let tH = inRect.size.height * hR;
        
        return CGRectMake(tX, tY, tW, tH);
    }
}
