//
//  ItemSelectedViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit
import RealmSwift

class ItemSelectedFooter: UIView, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource{
    //追加ボタンを押した際の処理（Realm導入後。AlarmSettingViewCellに反映させる？）
    @IBAction func addButtonAction(_ sender: UIButton) {
        
    }
    //項目一覧選択を紐付け
    @IBOutlet weak var itemSelectedPickerText: UITextField!
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    
    //UIPickerViewをインスタンス化
    var pickerView = UIPickerView()
    
    let masterItemViewController = MasterItemViewController()
    //項目設定オブジェクトの作成
    var masterItem = MasterItem()
    //項目設定のプロパティ
    var masterItemList: [MasterItem] = []
    //選択データ（項目名＋時間表示）
    //計算プロパティとしてmasterItemDataを宣言して初期化
    var masterItemData = ["abcdfg　１時間30分"]


    //未処理。//init関数に記載
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    //UITextField を選択したときに pickerView のキーボードが表示されるよう実装
    func createPickerView() {
        pickerView.delegate = self
        itemSelectedPickerText.inputView = pickerView
        //toolBarを定義
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ItemSelectedFooter.donePicker))
        toolBar.setItems([doneButtonItem], animated: true)
        itemSelectedPickerText.inputAccessoryView = toolBar
        
        print("処理実行1")
        }
    
    
    //toolbar上のボタン（done）を押すとキーボードを非表示にする
    @objc func donePicker() {
        itemSelectedPickerText.endEditing(true)
        print("処理実行2")
        }
    //キーボード以外の場所を押すとキーボードを非表示にする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemSelectedPickerText.endEditing(true)
        print("処理実行3")
        }
    //pickerView に表示する列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    //pickerView に表示するデータの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //MasterItemViewControllermasterItemListにある個数分セルを返却？
        return masterItemData.count
    }
    //pickerView に設定するデータを登録する
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return masterItemData[row]
    }
    //pickerView の各種データを選択したときに呼ばれるメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //UITextFieldに選択されたデータを表示
        itemSelectedPickerText.text = masterItemData[row]
    }
    //　追加ボタンの仕様
    func setupAddButton() {
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        
    }
    
    

    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //delegateの登録
        itemSelectedPickerText.delegate = self
        //UITextField を選択したときに pickerView のキーボードが表示
        createPickerView()
        //画面表示時に角丸を実装
        setupAddButton()
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
        }    }


    
}
