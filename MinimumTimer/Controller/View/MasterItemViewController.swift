//
//  MasterItemViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/23.
//

import UIKit
import RealmSwift

//delegateを定義
protocol MasterItemViewControllerDelegate{
    
}

class MasterItemViewController: UIViewController, MainAlarmViewCellDelegate, UITableViewDelegate, UITableViewDataSource, MasterItemViewCellDelegate {
    
    //＋ボタンが押された際の処理
    @IBAction func popUpButtonAction(_ sender: UIButton) {
        //Segue接続先へ遷移する処理
        performSegue(withIdentifier: "PopUpSegue", sender: nil)
        
    }
    //＋ボタンを紐付け
    @IBOutlet weak var popUpButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var masterItemTableView: UITableView!
    
    //項目設定のプロパティ
    var masterItemList: [MasterItem] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルの登録
        masterItemTableView.register(UINib(nibName: "MasterItemViewCell", bundle: nil), forCellReuseIdentifier: "MasterItemViewCell")
        //データソースの提供
        masterItemTableView.dataSource = self
        //delegateを登録
        masterItemTableView.delegate = self
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //ホーム画面表示時にボタンの仕様を適用
        configurePopUpButton()
        //項目が表示されるよう処理を実行
        setMasterItem()
    }
    
    //項目を格納するためのメソッド
    func setMasterItem() -> Void {
        //Realmをインスタンス化
        let realm = try! Realm()
        //RealmデータベースからMasterItem情報を取得しidの値で降順にソートする
        let result = realm.objects(MasterItem.self).sorted(byKeyPath: "id", ascending: false)
        //masterItemListに格納
        masterItemList = Array(result)
        
    }
    
    //＋ボタンの仕様
    func configurePopUpButton() {
        popUpButton.layer.cornerRadius = popUpButton.bounds.width / 2
    }
    
    //tableViewにAlarmSettingViewCellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //masterItemListにある個数分セルを返却
        return masterItemList.count
    }
    //tableViewにAlarmSettingViewCellを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成
        let masterItemViewCell = tableView.dequeueReusableCell(withIdentifier: "MasterItemViewCell", for: indexPath)as! MasterItemViewCell
        //セルの内容を設定
        let masterItemSetting = masterItemList[indexPath.row]
        //セルの定義
        //項目の作業時間のテキストデータ定義（データ変換(Date→テキスト)）
        masterItemViewCell.UserSetupTimeLabel.text = dateFormatter.string(from: masterItemSetting.userSetupTime)
        //項目の名前のテキストデータの定義
        masterItemViewCell.UserSetupNameLabel.text = String(masterItemSetting.userSetupName)
        //デリゲートの登録
        masterItemViewCell.delegate = self
        
        return masterItemViewCell
    }
    
    
}
