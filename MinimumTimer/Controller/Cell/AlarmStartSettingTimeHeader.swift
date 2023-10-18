//
//  AlarmStartSettingTimeViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit
import RealmSwift

// MARK: - classの定義＋機能追加
class AlarmStartSettingTimeHeader: UIView, UITextFieldDelegate {
    // MARK: - プロパティ
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartDatePickerText: UITextField!
    //toolBarを定義
    var toolBar:UIToolbar!

    // MARK: - 初期設定関数
    //未処理。//init関数に記載
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - 追加関数
    //doneボタンの設定
    func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneButton))
        toolBar.items = [toolBarButton]
        alarmStartDatePickerText.inputAccessoryView = toolBar
        
    }
    
    //doneボタンが押された際の処理
    @objc func doneButton() {
        // 完了ボタンが押された時の処理を記述する(閉じる)
        alarmStartDatePickerText.resignFirstResponder()
    }


    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //delegateの登録
        alarmStartDatePickerText.delegate = self
        //doneボタンの設定を画面表示時に実行
        setupToolbar()
        //枠線の設定
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomBorder)

        print("処理実行6")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
        print("処理実行7")
    }

    func loadNib() {
        guard UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first is UIView else {
                return
            }
        
        //File's Ownerを登録
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
        print("処理実行8")
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //テキストフィールドがタップされ、入力可能になった後の処理を記載
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    //datepickerが選択されたらtextfieldに表示・日付の値を設定する
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        alarmStartDatePickerText.text = dateFormatter.string(from: sender.date)
    }
    
}
