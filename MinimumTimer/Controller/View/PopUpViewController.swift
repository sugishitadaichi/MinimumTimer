//
//  PopUpViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/31.
//

import Foundation
import RealmSwift

class PopUpViewController: UIViewController, UITextFieldDelegate {
    //追加ボタンを押した際の処理
    @IBAction func addButtonAction(_ sender: UIButton) {
    }
        //キャンセルボタンを押した際の処理を紐付け
    @IBAction func cancelButtonAction(_ sender: Any) {
        //キャンセルすると画面を戻る処理
        dismiss(animated: true, completion: nil)
    }
    //ユーザーが追加した項目名を紐付け
    @IBOutlet weak var userSetupNameText: UITextField!
    //ユーザーが項目に設定した時間を紐付け
    @IBOutlet weak var userSetupTimeText: UITextField!

    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    
    //toolBarを定義
    var toolBar:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ポップアップの背景色を設定
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        //delegateの登録
        userSetupNameText.delegate = self
        userSetupTimeText.delegate = self
        //doneボタンの設定を画面表示時に実行
        setupToolbar()
        
    }
    
    //doneボタンの設定
    func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneButton))
        toolBar.items = [toolBarButton]
        userSetupTimeText.inputAccessoryView = toolBar
        
    }
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
        userSetupTimeText.text = dateFormatter.string(from: sender.date)
    }
    //doneボタンが押された際の処理
    @objc func doneButton() {
        // 完了ボタンが押された時の処理を記述する(閉じる)
        userSetupTimeText.resignFirstResponder()
    }
    
}
