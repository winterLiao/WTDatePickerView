# WTDatePickerView
simpleness pickerView   
![img](http://ok841h9gr.bkt.clouddn.com/%E6%97%A5%E6%9C%9F%E9%80%89%E6%8B%A9%E5%99%A8.gif)
### Show
```
       WTDatePickerView().show(title: "选择期限", defaultMinIndex: minIndex, defaultMaxIndex: maxIndex, LimitMaxIndex: 31, callback: { (leftIndex, rightIndx, dateString) in
            self.minIndex = leftIndex
            self.maxIndex = rightIndx
            self.dateLabel.text = dateString
        }) {
            print("取消")
        }
    }
```
