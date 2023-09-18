//
//  PopUpViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/31.
//

import UIKit
import RealmSwift

protocol PopUpViewControllerDelegate {
    func reflectMasterItem()
}

class PopUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
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
    //項目設定の配列のオブジェクトの作成
    var masterItemList: [MasterItem] = []
    //項目設定オブジェクトの作成
    var masterItem = MasterItem()
    //toolBarを定義
    var toolBar:UIToolbar!
    //delegateの定義
    var delegate: PopUpViewControllerDelegate?
    //項目名の文字数を10文字以内に定義
    let maxUserSetupNameLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ポップアップの背景色を設定
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        //userSetupNameTextのテキストにmasterItemの内容を代入
        userSetupNameText.text = String(masterItem.userSetupName)
        //userSetupHourTimeTextのテキストにmasterItemの内容をString型で代入
        userSetupHourTimeText.text = String(masterItem.userSetupHourTime)
        //userSetupMinutesTimeTextのテキストにmasterItemの内容をString型で代入
        userSetupMinutesTimeText.text = String(masterItem.userSetupMinutesTime)
        
        //delegateの登録
        userSetupHourTimeText.delegate = self
        userSetupMinutesTimeText.delegate = self
        userSetupNameText.delegate = self
        
        
        //時間設定のdoneボタンの設定を画面表示時に実行
        setupTimeTextToolbar()
        //項目名のdoneボタンの設定を画面表示時に実行
        setupNameTextToolbar()
        
    }
    
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
    
}
