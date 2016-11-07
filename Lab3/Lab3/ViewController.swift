//
//  ViewController.swift
//  Lab3
//
//  Created by Xiaoyi Xie on 9/23/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currCircle : CircleView? = nil
    
    var arraysOfPoints : [CGPoint]! = []
    var lastPoint = CGPointZero
    var newPoint = CGPointZero
    
    var currRadius = CGFloat(25.0)
    var currColor = UIColor.blackColor()
    var currLineStyle = false
    
    
    @IBAction func clearScreen(sender: AnyObject) {
        print("Time to clear")
        message.textColor = UIColor.blackColor()
        message.text = "Board all cleared"
        for v in view.subviews{
            if v is CircleView{
                v.removeFromSuperview()
            }
            else {
                print(v)
            }
        }
    }
    
    @IBAction func undoDrawing(sender: AnyObject) {
        print("Clear the former line")
        message.textColor = UIColor.blackColor()
        message.text = "Former line removed"
        let v = view.subviews.last
        if v is CircleView {
          v?.removeFromSuperview()
        }
        else {
            print(v)
        }
    }

    @IBAction func radiusManagement(sender: UISlider) {
        self.currRadius = CGFloat(sender.value*50)
        message.text = "The current radius of the pen is " + String(Int(sender.value*50))
    }
    
    @IBAction func color1(sender: UIButton) {
        currColor = UIColor.brownColor()
        message.textColor = UIColor.brownColor()
        message.text = "The pen color is brown now"
    }
    @IBAction func color2(sender: UIButton) {
        currColor = UIColor.redColor()
        message.textColor = UIColor.redColor()
        message.text = "The pen color is red now"
    }
    @IBAction func color3(sender: UIButton) {
        currColor = UIColor.blueColor()
        message.textColor = UIColor.blueColor()
        message.text = "The pen color is blue now"
    }
    @IBAction func color4(sender: UIButton) {
        currColor = UIColor.cyanColor()
        message.textColor = UIColor.cyanColor()
        message.text = "The pen color is cyan now"
    }
    @IBAction func color5(sender: UIButton) {
        currColor = UIColor.orangeColor()
        message.textColor = UIColor.orangeColor()
        message.text = "The pen color is orange now"
    }
    @IBAction func color6(sender: AnyObject) {
        currColor = UIColor.magentaColor()
        message.textColor = UIColor.magentaColor()
        message.text = "The pen color is magenta now"
    }
    
    @IBAction func lineStyle(sender: AnyObject) {
        if currLineStyle == true{
            currLineStyle = false
        }
        else {
            currLineStyle = true
        }
    }
    
    
    @IBOutlet weak var message: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = (touches.first)!.locationInView(self.view) as CGPoint
        print("the location is \(lastPoint)")
        arraysOfPoints.append(lastPoint)
        
        let myRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-100)
        currCircle = CircleView(frame: myRect)
        currCircle?.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(currCircle!)
        currCircle!.updateCircle(arraysOfPoints, radius: currRadius, color : currColor, line: currLineStyle)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        newPoint = (touches.first)!.locationInView(self.view) as CGPoint
        print("In touchesMoved at \(newPoint)")
        arraysOfPoints!.append(newPoint)
        currCircle!.updateCircle(arraysOfPoints, radius: currRadius, color: currColor, line: currLineStyle)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPoint = (touches.first)!.locationInView(self.view) as CGPoint
        print("Touches end at \(touchPoint)")
        arraysOfPoints.removeAll()
    }
    
    


}

