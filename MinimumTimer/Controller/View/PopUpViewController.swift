//
//  PopUpViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/31.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
protocol PopUpViewControllerDelegate {
    func reflectMasterItem()
}
// MARK: - classの定義＋機能追加
class PopUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: - 紐付け＋ボタンアクション
    //キャンセルボタンを押した際の処理を紐付け
    @IBAction func cancelButtonAction(_ sender: Any) {
        //キャンセルすると画面を戻る処理
        dismiss(animated: true, completion: nil)
    }
    //ユーザーが追加した項目名を紐付け
    @IBOutlet weak var userSetupNameText: UITextField!
    //ユーザーが項目に設定した時間（時間）を紐付け
    @IBOutlet weak var userSetupHourTimeText: UITextField!
    //ユーザーが項目に設定した時間（分）を紐付け
    @IBOutlet weak var userSetupMinutesTimeText: UITextField!

    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    //追加ボタンを押した際の処理
    @IBAction func addButtonAction(_ sender: UIButton) {
        //項目名のテキストの定義・nilの場合は空白を代入
        let updatedNameText = userSetupNameText.text ?? ""
        //時間設定のテキストの定義・nilの場合は0を代入
        let updatedHourText = Int(userSetupHourTimeText.text ?? "0") ?? 0
        let updatedMinutesText = Int(userSetupMinutesTimeText.text ?? "0") ?? 0
        //項目名をupdatedNameText（String型）に保存し画面を閉じる
        saveName(with: updatedNameText)
        //時間設定をupdatedHourText（Int型）に保存し画面を閉じる
        saveHourTime(with: updatedHourText)
        //時間設定をupdatedMinutesText（Int型）に保存し画面を閉じる
        saveMinutesTime(with: updatedMinutesText)
        
        //delegateの設定
        delegate?.reflectMasterItem()
    }
    
    // MARK: - プロパティ
    //項目設定オブジェクトの作成
    var masterItem = MasterItem()
    //toolBarを定義
    var toolBar:UIToolbar!
    //delegateの定義
    var delegate: PopUpViewControllerDelegate?
    //項目名の文字数を10文字以内に定義
    let maxUserSetupNameLength = 10
    //設定時間(時間)を0時間以上24時間未満に定義
    let hourTimeRange = 0..<24
    //設定時間(時間)を0分以上60分未満に定義
    let minutesTimeRange = 0..<60
    
    // MARK: - 初期設定関数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ポップアップの背景色を設定
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        //userSetupNameTextのテキストにmasterItemの内容を代入
        userSetupNameText.text = String(masterItem.userSetupName)
        //userSetupHourTimeTextのテキストにmasterItemの内容をString型で代入
        userSetupHourTimeText.text = String(masterItem.userSetupHourTime)
        //userSetupHourTimeTextのキーボードパットを数字のみの入力
        userSetupHourTimeText.keyboardType = UIKeyboardType.numberPad
        //userSetupMinutesTimeTextのテキストにmasterItemの内容をString型で代入
        userSetupMinutesTimeText.text = String(masterItem.userSetupMinutesTime)
        //userSetupMinutesTextのキーボードパットを数字のみの入力
        userSetupMinutesTimeText.keyboardType = UIKeyboardType.numberPad
        
        //delegateの登録
        userSetupHourTimeText.delegate = self
        userSetupMinutesTimeText.delegate = self
        userSetupNameText.delegate = self
        
        
        //時間設定のdoneボタンの設定を画面表示時に実行
        setupTimeTextToolbar()
        //項目名のdoneボタンの設定を画面表示時に実行
        setupNameTextToolbar()
        
    }
    
    // MARK: - 追加関数
    //項目名を保存・反映する処理
    func saveName(with text: String) {
        //Realmをインスタンス化
        let realm = try! Realm()
        //保存処理の実装
        try! realm.write {
            masterItem.userSetupName = text
            realm.add(masterItem)
        }
        //保存後、処理を閉じる
        dismiss(animated: true)
    }
    //時間設定(時間)を保存・反映する処理
    func saveHourTime(with text: Int) {
        //Realmをインスタンス化
        let realm = try! Realm()
        //保存処理の実装
        try! realm.write {
            masterItem.userSetupHourTime = text
            realm.add(masterItem)
        }
        //保存後、処理を閉じる
        dismiss(animated: true)
    }
    //時間設定(分)を保存・反映する処理
    func saveMinutesTime(with text: Int) {
        //Realmをインスタンス化
        let realm = try! Realm()
        //保存処理の実装
        try! realm.write {
            masterItem.userSetupMinutesTime = text
            realm.add(masterItem)
        }
        //保存後、処理を閉じる
        dismiss(animated: true)
    }
    //項目名のdoneボタンの設定
    func setupNameTextToolbar() {
        //項目名のdatepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let nameTextToolBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(nameTextDoneButton))
        toolBar.items = [nameTextToolBarButton]
        userSetupNameText.inputAccessoryView = toolBar
        
    }
    //項目名のdoneボタンが押された際の処理
    @objc func nameTextDoneButton() {
        // 時間設定のdoneボタンが押された時の処理を記述(閉じる)
        userSetupNameText.resignFirstResponder()
    }
    //時間設定のdoneボタンの設定と時刻表示
    func setupTimeTextToolbar() {
        //時間設定のdatepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let timeTextToolBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(timeTextDoneButton))
        toolBar.items = [timeTextToolBarButton]
        userSetupHourTimeText.inputAccessoryView = toolBar
        userSetupMinutesTimeText.inputAccessoryView = toolBar
        
    }
    //時間設定のdoneボタンが押された際の処理
    @objc func timeTextDoneButton() {
        // 時間設定のdoneボタンが押された時の処理を記述(閉じる)
        userSetupHourTimeText.resignFirstResponder()
        userSetupMinutesTimeText.resignFirstResponder()
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //項目名の文字数制限機能の追加
    //UITextViewのテキストが変更された時に呼ばれるデリゲートメソッド
    func textViewDidChangeSelection(_ textView: UITextView) {
        //テキストがnilでない場合
        guard userSetupNameText.text != nil else { return }
        //テキストの文字数が最大文字数を超えていた場合
        if userSetupNameText.text?.count ?? 0 > maxUserSetupNameLength {
            //最大文字数を超えた場合は切り捨て
            userSetupNameText.text = String(userSetupNameText.text!.prefix(maxUserSetupNameLength))
            
        }
    }
    //UITextFieldのテキストが変更された時に呼ばれるデリゲートメソッド
    internal func textFieldDidChangeSelection(_ textField: UITextField) {
        //テキストがnilでない場合
        guard userSetupNameText.text != nil else { return }
        //テキストの文字数が最大文字数を超えていた場合
        if userSetupNameText.text?.count ?? 0 > maxUserSetupNameLength {
            //　最大文字数を超えた場合は切り捨て
            userSetupNameText.text = String(userSetupNameText.text!.prefix(maxUserSetupNameLength))
            
        }
    }
    
    //数字制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //時間設定(時間)の数字制限
        if textField.accessibilityIdentifier == "itemHourTime" {
            //入力される文字列（時間）を取得
            let limitedHourTimeText = (userSetupHourTimeText.text ?? "") + string
            //入力されている文字列（時間）が数字でない場合や範囲外の数字の場合は入力を無効にする
            if let limitedHourTimeNumber = Int(limitedHourTimeText), hourTimeRange.contains(limitedHourTimeNumber) {
                    return true
                } else{
                    return false
                }
        }
        //時間設定(分)の数字制限
        if textField.accessibilityIdentifier == "itemMinutesTime" {
            //入力される文字列（分）を取得
            let limitedMinutesTimeText = (userSetupMinutesTimeText.text ?? "") + string
            //入力されている文字列（時間）が数字でない場合や範囲外の数字の場合は入力を無効にする
            if let limitedMinutesTimeNumber = Int(limitedMinutesTimeText), minutesTimeRange.contains(limitedMinutesTimeNumber) {
                    return true
                }    else{
                    return false
                }
            
        }
        //上記数字制限以外のテキストは有効にする（今回でゆうと項目名）
        return true
    }
    
}
