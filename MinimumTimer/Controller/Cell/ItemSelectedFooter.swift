//
//  ItemSelectedViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit
import RealmSwift

class ItemSelectedFooter: UIView, UITextFieldDelegate {
    //
    @IBOutlet weak var itemSelectedPickerText: UITextField!
    
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    
    //toolBarを定義
    var toolBar:UIToolbar!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //doneボタンの設定
    func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneButton))
        toolBar.items = [toolBarButton]
        itemSelectedPickerText.inputAccessoryView = toolBar
    }
    
    //テキストフィールがタップされ、入力可能になった後の処理を記載
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        print("処理実行3")
    }
    //datepickerが選択されたらtextfieldに表示・日付の値を設定する
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        itemSelectedPickerText.text = dateFormatter.string(from: sender.date)
        print("処理実行4")
    }
    
    //doneボタンが押された際の処理
    @objc func doneButton() {
        // 完了ボタンが押された時の処理を記述する(閉じる)
        itemSelectedPickerText.resignFirstResponder()
        print("処理実行5")
    }

    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //delegateの登録
        itemSelectedPickerText.delegate = self
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
        }    }


    
}
