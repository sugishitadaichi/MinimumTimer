//
//  AlarmStartSettingTimeViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit

class AlarmStartSettingTimeHeader: UIView {
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartDatePickerText: UITextField!

    var datePicker: UIDatePicker = UIDatePicker()
    
    //doneボタンが押された際の処理
    @objc func done() {
        // 完了ボタンが押された時の処理を記述する
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        alarmStartDatePickerText.inputView = datePicker
        

        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: alarmStartDatePickerText.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        alarmStartDatePickerText.inputView = datePicker
        alarmStartDatePickerText.inputAccessoryView = toolbar
        
        // デフォルト日付
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePicker.date = formatter.date(from: "2018-5-14")!
    }


    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    
}
