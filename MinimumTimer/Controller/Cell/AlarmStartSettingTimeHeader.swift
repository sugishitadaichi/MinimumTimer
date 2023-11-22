//
//  AlarmStartSettingTimeViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
//delegate
protocol AlarmStartSettingTimeHeaderDelegate{
    func setAllAlarmName(headerAlarmSetting: AlarmSetting)
    
    func saveAllAlarmName(with text: String)
}

// MARK: - classの定義＋機能追加
class AlarmStartSettingTimeHeader: UIView, UITextFieldDelegate {
    // MARK: - 紐付け＋ボタンアクション
    //アラーム名を紐付け
    @IBOutlet weak var alarmNameText: UITextField!
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartDatePickerText: UITextField!
    
    // MARK: - プロパティ
    //toolBarを定義
    var toolBar:UIToolbar!
    //アラーム設定オブジェクトの作成
    //var alarmSetting = AlarmSetting()
    //AlarmSettingの型を持つプロパティを作成
    //var headerAlarmSetting: AlarmSetting?
    //delegateの設定
    var delegate: AlarmStartSettingTimeHeaderDelegate?
    //項目名の文字数を10文字以内に定義
    let maxAlarmNameLength = 5
    

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
        alarmNameText.inputAccessoryView = toolBar
        
    }
    
    
    
    //doneボタンが押された際の処理
    @objc func doneButton() {
        //alarmStartDatePickerTextがタップされた場合の処理
        if alarmStartDatePickerText.isFirstResponder {
            //閉じる処理(datepicker)
            alarmStartDatePickerText.resignFirstResponder()
            //alarmStartDatePickerText以外（今回でゆうとalarmNameText）がタップされた場合の処理
        } else {
            //アラーム名のテキストの定義・nilの場合は空白
            let updatedAllAlarmNameText = alarmNameText.text ?? ""
            //アラーム名をupdatedAllAlarmNameText（String型）に保存
            delegate?.saveAllAlarmName(with: updatedAllAlarmNameText)
            //delegateの設定
            delegate?.setAllAlarmName(headerAlarmSetting: AlarmSetting)
            //閉じる処理(アラーム名)
            alarmNameText.resignFirstResponder()
            print("delegateが実装されました")
        }
    }


    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //delegateの登録
        alarmStartDatePickerText.delegate = self
        alarmNameText.delegate = self
        //doneボタンの設定を画面表示時に実行
        setupToolbar()
        //枠線の設定
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomBorder)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
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
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //textFieldがタップされ、編集が始まった時に呼ばれるメソッド
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //alarmStartDatePickerTextがタップされた場合の処理
        if textField == alarmStartDatePickerText {
            //UIDatePickerの型を持つdatePickerViewを生成
            let datePickerView:UIDatePicker = UIDatePicker()
            //datepickerのモードを時間モードに設定
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            //datepickerの外観のスタイルをホイールにする
            datePickerView.preferredDatePickerStyle = .wheels
            //テキストをdatepicker用の入力スタイルへ変更
            textField.inputView = datePickerView
            //datepickerが入力された際にこのclass(self)のdatePickerValueChangedメソッドを実行する
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
            //alarmStartDatePickerText以外（今回はalarmNameText）がタップされた場合の処理
        } else {
            //通常の入力スタイル
            textField.inputView = nil
        }
    }
    
    //UITextFieldのテキストが変更された時に呼ばれるデリゲートメソッド
    internal func textFieldDidChangeSelection(_ textField: UITextField) {
        //テキストがnilでない場合
        guard alarmNameText.text != nil else { return }
        //テキストの文字数が最大文字数を超えていた場合
        if alarmNameText.text?.count ?? 0 > maxAlarmNameLength {
            //　最大文字数を超えた場合は切り捨て
            alarmNameText.text = String(alarmNameText.text!.prefix(maxAlarmNameLength))
            
        }
    }
    
    //datepickerが選択されたらtextfieldに表示・日付の値を設定する
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        alarmStartDatePickerText.text = dateFormatter.string(from: sender.date)
        //出力確認
        print("\(String(describing: alarmStartDatePickerText.text))が入力されました")
    }
    
}
