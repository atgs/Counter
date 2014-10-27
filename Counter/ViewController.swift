//
//  ViewController.swift
//  Counter
//
//  Created by Kazuya Ueoka on 2014/10/23.
//  Copyright (c) 2014年 ATGS. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CounterCellTextField {

    var items :NSMutableArray?
    var cellIdentifier :String?
    var tableView :UITableView?
    var okButton :UIButton?
    var ngButton :UIButton?
    var soundButton :UIButton?
    
    var menuView :UIView?
    
    var soundPlayer :AVAudioPlayer?
    var okPlayer :AVAudioPlayer?
    var ngPlayer :AVAudioPlayer?
    
    var editingTextField :UITextField?
    
    override init() {
        super.init()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "tappedPlusButton:")
        self.navigationItem.rightBarButtonItem = plusButton
        
        var imageView :UIImageView = UIImageView(image: UIImage(named: "logo.png"))
        self.navigationItem.titleView = imageView
        
        self.items = NSMutableArray()
        self.cellIdentifier = "Cell"
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(CounterCell.self, forCellReuseIdentifier: self.cellIdentifier!)
        
        self.view.addSubview(self.tableView!)
        
        self.menuView = UIView(frame: CGRectZero)
        self.menuView?.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        self.view.addSubview(self.menuView!)
        
        self.soundButton = UIButton(frame: CGRectZero)
        self.soundButton?.setImage(UIImage(named: "sound.png"), forState: UIControlState.Normal);
        self.soundButton?.addTarget(self, action: "tappedSoundButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.menuView?.addSubview(self.soundButton!)
        
        self.okButton = UIButton(frame: CGRectZero)
        self.okButton?.setImage(UIImage(named: "ok.png"), forState: UIControlState.Normal);
        self.okButton?.addTarget(self, action: "tappedOkButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.menuView?.addSubview(self.okButton!)
        
        self.ngButton = UIButton(frame: CGRectZero)
        self.ngButton?.setImage(UIImage(named: "ng.png"), forState: UIControlState.Normal);
        self.ngButton?.addTarget(self, action: "tappedNgButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.menuView?.addSubview(self.ngButton!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!)
        var okURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ok", ofType: "mp3")!)
        var ngURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ng", ofType: "mp3")!)
        
        var error1 :NSError?
        self.soundPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: &error1)
        
        var error2 :NSError?
        self.okPlayer = AVAudioPlayer(contentsOfURL: okURL, error: &error2)
        
        var error3 :NSError?
        self.ngPlayer = AVAudioPlayer(contentsOfURL: ngURL, error: &error3)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView?.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height - 80.0)
        
        self.menuView?.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 80.0, width: self.view.frame.size.width, height: 80.0)
        
        var unitWidth = self.view.frame.size.width / 3.0
        var marginLeft = (unitWidth - 64.0) / 2.0
        
        self.soundButton?.frame = CGRect(x: (unitWidth * 0) + marginLeft, y: (80.0 - 64.0) / 2.0, width: 64.0, height: 64.0)
        self.okButton?.frame = CGRect(x: (unitWidth * 1) + marginLeft, y: (80.0 - 64.0) / 2.0, width: 64.0, height: 64.0)
        self.ngButton?.frame = CGRect(x: (unitWidth * 2) + marginLeft, y: (80.0 - 64.0) / 2.0, width: 64.0, height: 64.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedPlusButton(sender: AnyObject)
    {
        self.items?.addObject(NSMutableDictionary(dictionary: ["name": "", "count" : "0"]))
        
        self.tableView!.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell :CounterCell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier!, forIndexPath: indexPath) as CounterCell
        
        var item = items!.objectAtIndex(indexPath.row) as NSMutableDictionary
        
        cell.delegate = self
        cell.item = item
        cell.textField!.text = item.objectForKey("name") as? String
        cell.countLabel!.text = item.objectForKey("count") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tappedSoundButton(sender: AnyObject)
    {
        if (( self.soundPlayer?.playing ) == true)
        {
            self.soundPlayer?.stop()
        }
        
        self.soundPlayer?.prepareToPlay()
        self.soundPlayer?.play()
    }
    
    func tappedOkButton(sender: AnyObject)
    {
        if (( self.okPlayer?.playing ) == true)
        {
            self.okPlayer?.stop()
        }
        
        self.okPlayer?.prepareToPlay()
        self.okPlayer?.play()
    }
    
    func tappedNgButton(sender: AnyObject)
    {
        if (( self.ngPlayer?.playing ) == true)
        {
            self.ngPlayer?.stop()
        }
        
        self.ngPlayer?.prepareToPlay()
        self.ngPlayer?.play()
    }
    
    func keyboardWillShow(notif: NSNotification)
    {
        let userInfo = notif.userInfo!
        let keyboardScreenEndFrame   = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        let textFieldFrame = editingTextField!.convertRect(editingTextField!.bounds, toView: self.view)
        
        if ( keyboardScreenEndFrame.contains(CGPoint(x: textFieldFrame.origin.x, y: textFieldFrame.origin.y + textFieldFrame.size.height)) )
        {
            self.tableView?.contentInset = UIEdgeInsets(top: self.tableView!.contentInset.top, left: 0.0, bottom: keyboardScreenEndFrame.size.height, right: 0.0)
        }
    }
    
    func keyboardWillHide(notif: NSNotification)
    {
        self.tableView?.contentInset = UIEdgeInsets(top: self.tableView!.contentInset.top, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        self.editingTextField = textField
    }
    
    func textFieldEndEditing(textField: UITextField) {
        self.editingTextField = nil
    }
}

