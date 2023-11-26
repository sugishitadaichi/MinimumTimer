//
//  AlarmSettingViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/25.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
//delegateを定義
protocol AlarmSettingViewControllerDelegate{
    func saveMainAlarm()
}

// MARK: - classの定義＋機能追加
class AlarmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AlarmSettingViewCellDelegate, ItemSelectedFooterDelegate, AlarmStartSettingTimeHeaderDelegate {
    
    
    
    // MARK: - 紐付け＋ボタンアクション
    //キャンセルボタンを押した際の処理
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        //キャンセルした際に画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //終了予定時間表示を紐付け
    @IBOutlet weak var endSettingTimeLabel: UILabel!
    //保存ボタンを紐付け
    @IBOutlet weak var saveButton: UIButton!
    //保存ボタンを押した際の処理
    @IBAction func saveButtonAction(_ sender: UIButton) {
        // TODO: テキストへ保存する処理も必要？（Twitterサンプルアプリ.EVC.16~23行目参照）
        //delegateの設定
        delegate?.saveMainAlarm()
        //画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var alarmSettingTableView: UITableView!
    
    // MARK: - プロパティ
    //アラーム設定のプロパティ（配列）
    //var alarmSettingList: [AlarmSetting] = []
    //項目別アラームのプロパティ
    var alarmItemList: [AlarmItem] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //AlarmStartSettingTimeHeaderをインスタンス化
    var alarmStartSettingTimeHeader = AlarmStartSettingTimeHeader()
    //全体設定のオブジェクトの作成
    let ASVCAlarmSetting = AlarmSetting()
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()
    
    // MARK: - 初期設定関数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルの登録
        alarmSettingTableView.register(UINib(nibName: "AlarmSettingViewCell", bundle: nil), forCellReuseIdentifier: "AlarmSettingViewCell")
        //データソースの提供
        alarmSettingTableView.dataSource = self
        //delegateを登録
        alarmSettingTableView.delegate = self
        //alarmSettingTableViewに枠色を設定
        alarmSettingTableView.separatorColor = .black
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //フッタービューの設定
        //フッタービューの定義
        let footerHeight:CGFloat = 100.0
        let footerView = ItemSelectedFooter(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: footerHeight))
        
        //alarmSettingTableViewのtableFooterViewにフッタービューを設定
        alarmSettingTableView.tableFooterView = footerView
        //delegateの設定
        footerView.delegate = self
        
        
        
        //ヘッダービューの設定
        //ヘッダービューを定義
        let headerHeight:CGFloat = 100.0
        alarmStartSettingTimeHeader = AlarmStartSettingTimeHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        //userSetupNameTextのテキストにAlarmSetting.alarmNameの内容を代入
        alarmStartSettingTimeHeader.alarmNameText.text = ASVCAlarmSetting.alarmName
        //alarmSettingTableViewのtableHeaderViewにヘッダービューを設定
        alarmSettingTableView.tableHeaderView = alarmStartSettingTimeHeader
        //setHeaderメソッドを画面が表示される際に実行
        //setHeader()
        //setAlarmItemメソッドを画面が表示される際に実行
        setAlarmItem()
        
        //delegate
        alarmStartSettingTimeHeader.delegate = self
    }
    
    
    // MARK: - 追加関数
    //ヘッダーに表示するデータの処理(フッターは項目追加処理のみのため不要)
//    func setHeader() -> Void {
//
//        //dateFormatterを定義
//        let dateFormatter = DateFormatter()
//        //Date型への変換
//        dateFormatter.dateFormat = "HH:mm"
//        //Realmをインスタンス化
//        let realm = try! Realm()
//        //アラーム設定を表示する際の条件（時間の昇順）
//        let resultAlarmTime = realm.objects(AlarmSetting.self).sorted(byKeyPath: "alarmStartSettingTime", ascending: true)
//        //alarmSettingListに格納
//        alarmSettingList = Array(resultAlarmTime)
//        
//    }
    
    //項目別設定を格納するためのメソッド
    func setAlarmItem() -> Void {
        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //Realmをインスタンス化
        let realm = try! Realm()
        //項目別設定を表示する際の条件（idの降順）
        let resultItem = realm.objects(AlarmItem.self).sorted(byKeyPath: "id", ascending: true)
        //alarmItemListに格納
        alarmItemList = Array(resultItem)
    }
    
    // MARK: - delegateメソッド（AlarmSettingViewCell）
    //削除処理の実装
    func deleteItem(item: AlarmItem) {
        //alarmSettingListの配列からインデックス番号に該当する配列を削除
        if let index = alarmItemList.firstIndex(of: item) {
            alarmItemList.remove(at: index)
        }
        //更新
        alarmSettingTableView.reloadData()
        
    }
    
    // MARK: - delegateメソッド（ItemSelectedFooter）
    //項目別の時間の実装（Footerからのdelegateメソッド）
    func reflectItemData(selectedMasterItem: MasterItem) {
        //項目設定オブジェクトの作成(ローカル変数)
        let alarmItem = AlarmItem()
        
        //　項目名の実装ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        //alarmItemとselectedMasteItemのuserSetupNameの共通化（継承）
        alarmItem.userSetupName = selectedMasterItem.userSetupName
        //　項目名の実装終了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        //　時間の実装ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        //day（現在時刻）を設定
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        //項目マスタをアラーム時間と足し合わせる
        //（１項目＝アラーム時間+項目設定時間　２項目目以降＝アラーム時間＋1項目目の項目設置時間+2項目目の項目設置時間...）
        //項目別開始時間(itemStartTime）をDate型で定義
        var itemStartTime: Date
        //alarmItemListが0の場合（項目が追加されていない場合）、ヘッダーの時間を開始時間に反映
        //Date型に変換できなかった場合は、現在時刻を反映
        if alarmItemList.count == 0 {
            //文字列→Date型にするために日付を追加（yyyy/MM/dd HH:mm式でないと認識しないため）
            let dateString = "2023/11/2 " +   alarmStartSettingTimeHeader.alarmStartDatePickerText.text!
            
            itemStartTime = dateFormatter.date(from: dateString) ?? Date()
            //alarmItemListが0でない場合（項目が追加されている場合）
            //alarmItemListの最後の時間の終了予定時間（byItemEndTime）を反映
        } else {
            itemStartTime = alarmItemList.last?.byItemEndTime ?? Date()
        }
        //itemStartTimeとalarmItem.byItemStartTimeの共通化
        alarmItem.byItemStartTime = itemStartTime
                
        //項目別終了時間の反映＝時間を足し合わせる設定(時間)
        let modifiedItemEndHourTime = Calendar.current.date(byAdding: .hour, value: selectedMasterItem.userSetupHourTime, to: itemStartTime)!
        //項目別終了時間の反映＝時間を足し合わせる設定(分)
        let modifiedItemEndTime = Calendar.current.date(byAdding: .minute, value: selectedMasterItem.userSetupMinutesTime, to: modifiedItemEndHourTime)!
        //テキスト・alarmSettingモデル・合計時間の共通化
        alarmItem.byItemEndTime = modifiedItemEndTime
        
        //全体の終了時間
        //全体の終了時間プロパティの定義
        var alarmEndTime: Date
        
        //文字列→Date型にするために日付を追加（yyyy/MM/dd HH:mm式でないと認識しないため）
        let dateEndString = "\(modifiedItemEndTime.toStringWithCurrentLocale())"
        //dateEndStringの文字列をDate型に変換
        alarmEndTime = dateFormatter.date(from: dateEndString) ?? Date()
        //alarmEndTimeをalarmItem.byItemEndTimeへ共通化
        alarmEndTime = alarmItem.byItemEndTime
        //alarmEndTimeをalarmSettingObjects.alarmEndSettingTimeへ共通化
        ASVCAlarmSetting.alarmEndSettingTime = alarmEndTime
        //全体の終了時間のテキストへ反映
        endSettingTimeLabel.text = alarmEndTime.formattedTime() 
        //　時間の実装終了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        //　追加・反映の実装ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        //alarmItemListに新しいalarmItemを追加(追加ボタンを押した際のデータ追加)
        alarmItemList.append(alarmItem)
        //データ反映
        alarmSettingTableView.reloadData()
        //　追加・反映の実装終了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
    }
    
    // MARK: - delegateメソッド（AlarmStartSettingTimeHeader）
    //アラーム名を保存・反映する処理
    func saveAllAlarmName(with text: String) {
        //Realmをインスタンス化
        let realm = try! Realm()
        //保存処理の実装
        try! realm.write {
            ASVCAlarmSetting.alarmName = text
            realm.add(ASVCAlarmSetting)
        }
        print("ASVCAlarmSetting.alarmNameは\(ASVCAlarmSetting.alarmName)です")
        
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //tableViewにAlarmSettingViewCellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //alarmItemListにある個数分セルを返却
        return alarmItemList.count
    }
    
    //tableViewにAlarmSettingViewCellを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成
        let alarmSettingViewCell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingViewCell", for: indexPath)as! AlarmSettingViewCell
        
        //セルの内容を設定
        let alarmItemSetting = alarmItemList[indexPath.row]
        //セルの定義
        //セルの項目マスタとalarmItemListの共通化
        alarmSettingViewCell.alarmItem = alarmItemSetting
        
        //項目別開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        alarmSettingViewCell.itemStartTimeLabel.text = dateFormatter.string(from: alarmItemSetting.byItemStartTime)
        //項目別開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        alarmSettingViewCell.itemEndTimeLabel.text = dateFormatter.string(from: alarmItemSetting.byItemEndTime)
        //項目名のテキストデータを定義
        alarmSettingViewCell.userSetupNameLabel.text = alarmItemSetting.userSetupName
        //indexpath
        alarmSettingViewCell.indexPath = indexPath
        //デリゲートの登録
        alarmSettingViewCell.delegate = self

        
        return alarmSettingViewCell
    }
    
    //テーブルビューにセルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

    
}

// MARK: - 追加機能
//Date型に日本時間が反映できる処理の追加
extension Date {
    //日本時刻表示
    func toStringWithCurrentLocale() -> String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy/MM/dd HH:mm"

        return formatter.string(from: self)
    }
    //特定のテキストにのみ"HH:mm"を適用させる
    func formattedTime() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }

}
