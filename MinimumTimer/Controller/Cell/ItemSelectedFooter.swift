//
//  ItemSelectedViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit
import RealmSwift
// MARK: - delegateの定義
//delegateを定義
protocol ItemSelectedFooterDelegate{
    func reflectItemData(selectedMasterItem: MasterItem)
}

// MARK: - classの定義＋機能追加
class ItemSelectedFooter: UIView, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - 紐付け＋ボタンアクション
    //項目一覧選択を紐付け
    @IBOutlet weak var itemSelectedPickerText: UITextField!
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    //追加ボタンを押した際の処理（Realm導入後。AlarmSettingViewCellに反映させる？）
    @IBAction func addButtonAction(_ sender: UIButton) {
        //項目セルのデータ反映の処理（delegate）
        delegate?.reflectItemData(selectedMasterItem: selectedMasterItem!)
        
        
    }
    
    // MARK: - プロパティ
    //UIPickerViewをインスタンス化
    var pickerView = UIPickerView()
    //項目設定オブジェクトの作成
    var masterItem = MasterItem()
    //項目設定のプロパティ（配列）
    var masterItemList: [MasterItem] = []
    //項目設定のプロパティの宣言
    var selectedMasterItem: MasterItem?
    //AlarmSettingViewCellをインスタンス化
    let alarmSettingViewCell = AlarmSettingViewCell()
    //delegateの定義
    var delegate: ItemSelectedFooterDelegate?
    //選択データ（項目名＋時間表示）
    //計算型プロパティとしてmasterItemDataを宣言して初期化
    var masterItemFooterSetting: String {
        let pickerViewTextMasterItem = masterItem
        return "\(pickerViewTextMasterItem.userSetupName)   \(pickerViewTextMasterItem.userSetupHourTime)時間 \(pickerViewTextMasterItem.userSetupMinutesTime)分"
    }
    //masterItemFooterSettingを基に配列masterItemDataを作成
    var masterItemData: [String] {
        return [masterItemFooterSetting]
        
    }


    // MARK: - 初期設定関数
    //未処理。//init関数に記載
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    // MARK: - 追加関数
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //delegateの登録
        itemSelectedPickerText.delegate = self
        //delegate・datesourceの登録
        pickerView.delegate = self
        pickerView.dataSource = self
        //UITextField を選択したときに pickerView のキーボードが表示
        createPickerView()
        //画面表示時に角丸を実装
        setupAddButton()
        //枠線の設定
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomBorder)
        //項目が表示されるよう処理を実行
        setItemSelectedMasterItem()
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
    
    
    
    //項目を格納するためのメソッド(配列)
    func setItemSelectedMasterItem() -> Void {
        //Realmをインスタンス化
        let realm = try! Realm()
        //項目を表示する際の条件(項目設定時間の時間の昇順・分の昇順)
        let sortProperties = [
            SortDescriptor(keyPath: "userSetupHourTime", ascending: true),
            SortDescriptor(keyPath: "userSetupMinutesTime", ascending: true)
        ]
        //RealmデータベースからMasterItem情報を取得しidの値で降順にソートする
        let timeResult = realm.objects(MasterItem.self).sorted(by: sortProperties)
        //masterItemListに格納
        masterItemList = Array(timeResult)
        
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
        }
    
    
    //toolbar上のボタン（done）を押すとキーボードを非表示にする
    @objc func donePicker() {
        itemSelectedPickerText.endEditing(true)
        }
    //　追加ボタンの仕様
    func setupAddButton() {
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //キーボード以外の場所を押すとキーボードを非表示にする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemSelectedPickerText.endEditing(true)
        }
    
    //pickerView に表示する列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    //pickerView に表示するデータの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //MasterItemViewController（項目一覧画面）のmasterItemListにある個数分セルを返却
        return masterItemList.count
    }
    //pickerView に設定するデータ(配列)を登録する（Int型→String型の文字列の変換が必要）
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //masterItemList[row]をpickerViewMasterItemとして定義
        let pickerViewMasterItem = masterItemList[row]
        //文字列として変換し表示を返す
        return "\(pickerViewMasterItem.userSetupName)   \(pickerViewMasterItem.userSetupHourTime)時間 \(pickerViewMasterItem.userSetupMinutesTime)分"
    }
    //pickerView の各種データを選択したときに呼ばれるメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //masterItemList[row]をpickerViewMasterItemとして定義
        let pickerViewMasterItem = masterItemList[row]
        //masterItemList[row] を選択されたマスタ情報として selectedMasterItem にも代入する
        selectedMasterItem = masterItemList[row]
        //UITextFieldに選択されたデータを表示（文字列化）
        itemSelectedPickerText.text = "\(pickerViewMasterItem.userSetupName)   \(pickerViewMasterItem.userSetupHourTime)時間 \(pickerViewMasterItem.userSetupMinutesTime)分"
        
    }
    
    
}
