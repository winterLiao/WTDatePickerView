//
//  WTDatePickerView.swift
//  WTDatePickerView
//
//  Created by liaowentao on 17/2/28.
//  Copyright © 2017 Haochuang. All rights reserved.
//

import UIKit

class WTDatePickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    //点击回调
    public typealias DatePickerCallback = (_ leftIndex: NSInteger,_ rightIndex:NSInteger,_ dateString:String) -> Void
    public typealias DatePickerCancelCallback = () -> Void

    private let KDatePickerDoneButtonTag : Int = 1
    
    private var string1 : String = ""
    private var string2 : String = ""
    private var index1  : NSInteger = 0
    private var index2  : NSInteger = 0
    private var titleString : String = ""
    private var maxLimitIndex : NSInteger = 0
    private var callback : DatePickerCallback?
    private var cancelCallback : DatePickerCancelCallback?

    //MARK: -长宽设置
    let topViewHeight : CGFloat = 40
    let bottomHeight : CGFloat = 40
    let containerWidth : CGFloat = SCREEN_WIDTH * 0.7
    let containerHeight : CGFloat = SCREEN_WIDTH * 0.7
    let pickerViewBackGroundColor : UIColor = UIColor.orange

    lazy var dataArray : [String]  = {
        var dataArray : [String] = []
        for index in 0...self.maxLimitIndex{
            let motnthDate = "\(index)天"
            dataArray.append(motnthDate)
        }
        return dataArray
    }()

    lazy var datePickViewer : UIPickerView = {
        var datePickView = UIPickerView()
        datePickView.backgroundColor = UIColor.white
        datePickView.delegate = self
        datePickView.dataSource = self
        datePickView.frame = CGRect(x: 0, y: self.topViewHeight, width: self.containerWidth, height:self.containerHeight - self.topViewHeight - self.bottomHeight)
        return datePickView
    }()
    
    lazy var topView : UIView = {
        var topView = UIView()
        topView.frame = CGRect(x: 0, y: 0, width:self.containerWidth, height: self.topViewHeight)
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: self.containerWidth, height: self.topViewHeight))
        label.text = self.titleString
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = self.pickerViewBackGroundColor
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        topView.addSubview(label)
        return topView
    }()
    
    lazy var containerView : UIView = {
        var containerView = UIView(frame: CGRect(x: (SCREEN_WIDTH - self.containerWidth) / 2.0, y: SCREEN_HEIGHT * 0.26, width: self.containerWidth, height: self.containerHeight))
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(self.topView)
        containerView.addSubview(self.datePickViewer)
        
        var lineView1 = UIView(frame: CGRect(x: 0, y: self.containerHeight - self.bottomHeight - LineWidth, width: self.containerWidth, height: LineWidth))
        lineView1.backgroundColor = self.pickerViewBackGroundColor
        containerView.addSubview(lineView1)
        
        var lineView2 = UIView(frame:CGRect(x:self.containerWidth * 0.5 - LineWidth,  y:self.containerHeight - self.bottomHeight, width:LineWidth, height:self.bottomHeight))
        lineView2.backgroundColor = self.pickerViewBackGroundColor
        containerView.addSubview(lineView2)
        
        containerView.addSubview(self.createCancelButton())
        containerView.addSubview(self.createChooseButton())

        return containerView
    }()
    
    func createCancelButton() -> UIButton{
        //取消按钮
        let cancelBtn = UIButton()
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.frame = CGRect(x:0, y:self.containerHeight - self.bottomHeight, width:self.containerWidth * 0.5, height:self.bottomHeight)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.layer.cornerRadius = 2
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.layer.masksToBounds = true
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(ButtonTaped), for: .touchUpInside)
        return cancelBtn
    }
    
    func createChooseButton() -> UIButton{
        //确定按钮
        let chooseButton = UIButton()
        chooseButton.backgroundColor = UIColor.clear
        chooseButton.frame = CGRect(x:self.containerWidth * 0.5, y: self.containerHeight - bottomHeight, width: self.containerWidth * 0.5, height: self.bottomHeight)
        chooseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        chooseButton.layer.cornerRadius = 2
        chooseButton.layer.masksToBounds = true
        chooseButton.backgroundColor = UIColor.clear
        chooseButton.tag = KDatePickerDoneButtonTag
        chooseButton.setTitleColor(self.pickerViewBackGroundColor, for: .normal)
        chooseButton.setTitle("确定", for: .normal)
        chooseButton.addTarget(self, action: #selector(ButtonTaped), for: .touchUpInside)
        return chooseButton
    }
    
    
    // MARK: - buttonTap
    func ButtonTaped(sender : UIButton!){
        if sender.tag == KDatePickerDoneButtonTag {
            var leftAndRightString : String = "";
            
            if (self.index1 > self.index2) {
                
                
            } else if (self.index1 == self.index2 ) {
                
                leftAndRightString = string2;
                
            }else {
                
                leftAndRightString = "\(string1)~\(string2)"
                
            }
        
            self.callback!(self.index1,self.index2,leftAndRightString)
        }else{
            self.cancelCallback!()
        }
        
        dissMissView()
    }
    
    open func show(title:String,defaultMinIndex: NSInteger,defaultMaxIndex:NSInteger, LimitMaxIndex:NSInteger,callback:@escaping DatePickerCallback,cancelCallback:@escaping DatePickerCancelCallback){
        self.titleString = title
        self.string1 = "\(defaultMaxIndex)天"
        self.string2 = "\(defaultMaxIndex)天"
        self.maxLimitIndex = LimitMaxIndex
        self.callback = callback
        self.cancelCallback = cancelCallback
        self.backgroundColor = UIColor.rgbaColorFromHex(rgb: 0x111111, alpha: 0.7)
        self.addSubview(self.containerView)
        self.index1 = defaultMinIndex
        self.index2 = defaultMaxIndex
        self.datePickViewer.selectRow(self.index1, inComponent: 0, animated: true)
        self.datePickViewer.selectRow(self.index2, inComponent: 2, animated: true)
        let currentWindows : UIWindow = UIApplication.shared.keyWindow!;
        self.frame = UIScreen.main.bounds
        currentWindows.addSubview(self);
    }
    
//    open func pickerViewDidSelectRowWithLeftIndex(leftIndex:NSInteger,rightIndex:NSInteger){
//        self.string1 = "\(leftIndex)天";
//        self.string2 = "\(rightIndex)天";
//        self.index1 = leftIndex;
//        self.index2 = rightIndex;
//        self.datePickViewer.selectRow(self.index1, inComponent: 2, animated: true)
//        self.datePickViewer.selectRow(self.index2, inComponent: 2, animated: true)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dissMissView()
    }

    func dissMissView() {
        UIView.animate(withDuration: 0.25, animations: { 
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut)
            self.containerView.frame = CGRect(x: (SCREEN_WIDTH - self.containerWidth) / 2.0, y: SCREEN_HEIGHT, width: self.containerWidth, height: self.containerHeight)
        }, completion: { (Bool) in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - pickerView Delegate&dataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dataArray.count
        }
        else if component == 1{
            return 1
        }
        else if component == 2{
            return dataArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (component) {
        case 0:
            
            return  self.dataArray[row];
        case 1:
            
            return  "~"

        case 2:
            
            return  self.dataArray[row];
            
        default:
            return nil;
        }

    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selStr = self.dataArray[row]
        
        switch(component) {
        case 0:
            
            self.string1 = selStr;
            
            self.index1 = self.dataArray.index(of: selStr)!;
            
            if (self.index1 < self.index2) {
                
            } else {
                
                self.datePickViewer.selectRow(row, inComponent: 2, animated: true)
                self.index2 = self.index1;
                self.string2 = self.string1;
            }
            
            
        case 2:
            
            self.string2 = selStr;
            
            self.index2 = self.dataArray.index(of: selStr)!;
            
            if (self.index2 < self.index1) {
                
                self.datePickViewer.selectRow(self.index1, inComponent: 2, animated: true)
                self.string2 = self.dataArray[self.index1];
                self.index2 = self.index1;
                
            } else {
                
                self.string2 = self.dataArray[self.index2];
                
            }
            
        default: break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel : UILabel
        if (view as? UILabel) != nil {
            pickerLabel = view as! UILabel!
        }else{
            pickerLabel = UILabel()
            pickerLabel.font = UIFont.systemFont(ofSize: 16)
            pickerLabel.textColor = UIColor.black
            pickerLabel.backgroundColor = UIColor.clear
        }
        switch (component) {
        case 0:
            pickerLabel.textAlignment = .right
        case 1:
            pickerLabel.textAlignment = .center
        case 2:
            pickerLabel.textAlignment = .left
        default: break
        }
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel;
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

}
