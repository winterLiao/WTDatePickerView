//
//  ViewController.swift
//  WTDatePickerView
//
//  Created by liaowentao on 17/2/28.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    var minIndex = 10
    var maxIndex = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func selectTheDate(_ sender: Any) {
        
        WTDatePickerView().show(title: "选择期限", defaultMinIndex: minIndex, defaultMaxIndex: maxIndex, LimitMaxIndex: 31, callback: { (leftIndex, rightIndx, dateString) in
            self.minIndex = leftIndex
            self.maxIndex = rightIndx
            self.dateLabel.text = dateString
        }) {
            print("取消")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

