//
//  CounterCell.swift
//  Counter
//
//  Created by Kazuya Ueoka on 2014/10/23.
//  Copyright (c) 2014年 ATGS. All rights reserved.
//

import UIKit

protocol CounterCellTextField
{
    func textFieldBeginEditing(textField: UITextField) -> Void
    func textFieldEndEditing(textField: UITextField) -> Void
}

class CounterCell : UITableViewCell, UITextFieldDelegate
{
    var textField :UITextField?
    var plusButton :UIButton?
    var minusButton :UIButton?
    var countLabel :UILabel?
    var item :NSMutableDictionary?
    var delegate :CounterCellTextField?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.textField = UITextField(frame: CGRectZero)
        self.textField?.placeholder = "Name"
        self.textField?.font = UIFont.systemFontOfSize(30.0)
        self.textField?.returnKeyType = UIReturnKeyType.Done
        self.textField?.delegate = self
        self.addSubview(self.textField!)
        self.countLabel = UILabel(frame: CGRectZero)
        self.countLabel?.font = UIFont.systemFontOfSize(30.0)
        self.countLabel!.text = "0"
        self.countLabel!.textAlignment = NSTextAlignment.Center
        self.addSubview(self.countLabel!)
        self.plusButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.plusButton?.setTitle("+", forState: UIControlState.Normal)
        self.plusButton?.titleLabel?.textColor = UIColor.whiteColor()
        self.plusButton?.backgroundColor = UIColor.grayColor()
        self.plusButton?.addTarget(self, action: "tappedPlusButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.plusButton!)
        self.minusButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.minusButton?.setTitle("-", forState: UIControlState.Normal)
        self.minusButton?.titleLabel?.textColor = UIColor.whiteColor()
        self.minusButton?.backgroundColor = UIColor.grayColor()
        self.minusButton?.addTarget(self, action: "tappedMinusButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.minusButton!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textField!.frame = CGRect(x: 10.0, y: 10.0, width: self.frame.size.width - 270.0, height: self.frame.size.height - 20.0)
        self.countLabel!.frame = CGRect(x: CGRectGetMaxX(self.textField!.frame) + 10.0, y: 10.0, width: 80.0, height: self.frame.size.height - 20.0)
        
        self.plusButton!.frame = CGRect(x: CGRectGetMaxX(self.countLabel!.frame) + 10.0, y: 10.0, width: 80.0, height: 80.0)
        self.minusButton!.frame = CGRect(x: CGRectGetMaxX(self.plusButton!.frame) + 10.0, y: 10.0, width: 80.0, height: 80.0)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.textFieldBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        item!.setObject(textField.text, forKey: "name")
        
        self.delegate?.textFieldEndEditing(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func tappedPlusButton(sender: AnyObject)
    {
        var text :String = self.item!.objectForKey("count") as String
        var count = text.toInt()!
        count++
        self.countLabel!.text = String(count)
        
        self.item!["count"] = self.countLabel!.text
    }
    
    func tappedMinusButton(sender: AnyObject)
    {
        var text :String = self.item!.objectForKey("count") as String
        var count = text.toInt()!
        count--
        self.countLabel!.text = String(count)
        
        self.item!["count"] = self.countLabel!.text
    }
}
