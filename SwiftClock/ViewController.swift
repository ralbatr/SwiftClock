//
//  ViewController.swift
//  SwiftClock
//
//  Created by Ralbatr Yi on 15-4-7.
//  Copyright (c) 2015年 Ralbatr Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // UI控件
    var timeLabel:UILabel? // 显示剩余时间
    var startStopButton:UIButton? // 开始、停止按钮
    var clearButton:UIButton? // 复位按钮
    var timeButtons:[UIButton]? // 设置时间的按钮数组
    let timeButtonInfos = [("1分",60),("3分",180),("5分",300),("秒",1)];
    
    // 计时器
    var timer:NSTimer?
    
    var isCounting:Bool = false {
        willSet(newValue){
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil;
            }
            setSettingButtonsEnabled(!newValue)
        }
    }
//  计时时间
    var remainingSeconds:Int = 0 {
        willSet(newSeconds){
            let mins = newSeconds/60
            let seconds = newSeconds%60
            self.timeLabel!.text = NSString(format:"%02d:%02d", mins, seconds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.brownColor();
        setupTimeLabel()
        setupActionButtons()
        setupTimeButtons()
        
        remainingSeconds = 0
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame = CGRectMake(10, 40, self.view.bounds.width-20, 120)
        
//        let gap = (self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count)*64))/CGFloat(timeButtons!.count-1)
        let gap1 = (self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count*64)))
        let gap = gap1/CGFloat(timeButtons!.count)
//       Expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions
        for(index,button) in enumerate(timeButtons!) {
            let buttonLeft = 10 + (64+gap)*CGFloat(index)
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
            
        }

        startStopButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.width-20-100, 44)
        clearButton!.frame = CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44)
    }
    // UI helpers
    func setupTimeLabel() {
        timeLabel = UILabel();
        timeLabel!.textColor = UIColor.whiteColor();
        timeLabel!.font = UIFont(name: "Helvetica", size: 80);
        timeLabel!.backgroundColor = UIColor.blackColor();
        timeLabel!.textAlignment = NSTextAlignment.Center;
        
        self.view.addSubview(timeLabel!)
    }
    
    func setupTimeButtons(){
//        var buttons:[UIButton] = []
        var buttons:[UIButton] = [UIButton]()
//        var buttons:Array = Array<UIButton>()
        for(index,(title,_)) in enumerate(timeButtonInfos){
            
            let button:UIButton = UIButton()
            button.tag = index
            button.setTitle("\(title)", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            button.backgroundColor = UIColor.orangeColor()
            buttons += [button]
            self.view.addSubview(button)
        }
        timeButtons = buttons
    }
    func setupActionButtons(){
        startStopButton = UIButton();
        startStopButton!.backgroundColor = UIColor.redColor();
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitle("启动/停止", forState: UIControlState.Normal)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startStopButton!)
        
        clearButton = UIButton();
        
        clearButton!.backgroundColor = UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("复位", forState: UIControlState.Normal);
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(clearButton!);
    }
    
    func startStopButtonTapped(sender:UIButton){
        isCounting = !isCounting
        
        if isCounting {
            createAndFireLoclNotificationAfterSeconds(remainingSeconds)
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    func clearButtonTapped(sender:UIButton){
        remainingSeconds = 0
    }
    
    func timeButtonTapped(sender:UIButton){
        let (_,seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    
    func updateTimer(timer: NSTimer) {
        if remainingSeconds <= 0 {
            isCounting = false
            let alert = UIAlertView()
            alert.title = "计时完成！"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
        }else{
            remainingSeconds--
        }
    }
    
    func setSettingButtonsEnabled(enabled:Bool){
        for button in self.timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 :0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 :0.3
    }
    
    func createAndFireLoclNotificationAfterSeconds(seconds:Int) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notificaiton = UILocalNotification()
        
        let timeIntervalSinceNow:Double = Double(seconds)
        
        notificaiton.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow)
        
        notificaiton.alertBody = "计时完成"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notificaiton)
    }
    
}

