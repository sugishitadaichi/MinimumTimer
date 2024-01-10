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
    func arrayMainAlarm()
}

// MARK: - classの定義＋機能追加
class AlarmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AlarmSettingViewCellDelegate, ItemSelectedFooterDelegate {
    
    
    
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
        saveMainAlarm()
        print("設定したidは\(alarmSetting.id)")
        //delegateの設定（整列と更新）
        delegate?.arrayMainAlarm()
        //画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var alarmSettingTableView: UITableView!
    
    // MARK: - プロパティ
    //項目別アラームのプロパティ
    var alarmItemList: [AlarmItem] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //AlarmStartSettingTimeHeaderをインスタンス化
    var alarmStartSettingTimeHeader = AlarmStartSettingTimeHeader()
    //全体設定のプロパティの作成
    var alarmSetting = AlarmSetting()
    //各作業内容のプロパティの作成
    //var alarmItem = AlarmItem()
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
        alarmStartSettingTimeHeader.alarmNameText.text = alarmSetting.alarmName
        //alarmSettingTableViewのtableHeaderViewにヘッダービューを設定
        alarmSettingTableView.tableHeaderView = alarmStartSettingTimeHeader
        
        //alarmStartDatePickerTextのテキストにalarmSetting.alarmStartSettingTimeを代入
            alarmStartSettingTimeHeader.alarmStartDatePickerText.text = "\(alarmSetting.alarmStartSettingTime.formattedTime())"
        
        print("alarmStartSettingTimeHeader.alarmStartDatePickerText.textの時間は\(String(describing: alarmStartSettingTimeHeader.alarmStartDatePickerText.text))です")
        
        

        //setAlarmItemメソッドを画面が表示される際に実行
        //setAlarmItem()
        
    }
    
    
    // MARK: - 追加関数
    // TODO: 不要？今後検討（設定の新規作成の際に前回や前々回の設定項目が引き継がれる）
    //項目別設定を格納するためのメソッド
//    func setAlarmItem() -> Void {
//        //dateFormatterを定義
//        let dateFormatter = DateFormatter()
//        //Date型への変換？
//        dateFormatter.dateFormat = "HH:mm"
//        //Realmをインスタンス化
//        let realm = try! Realm()
//        //項目別設定を表示する際の条件（idの降順）
//        let resultItem = realm.objects(AlarmItem.self).sorted(byKeyPath: "id", ascending: true)
//        //alarmItemListに格納
//        alarmItemList = Array(resultItem)
//    }
    
    //AlarmSettingプロパティで諸々のデータを保存（試し）
    func saveMainAlarm() {
        //Realmをインスタンス化
        let realm = try! Realm()
        //alarmItemListの保存
        try! realm.write {
            realm.add(alarmItemList)
        }
        print("alarmItemListの内容は\(alarmItemList)")
        //alarmSettingプロパティへデータ保存
        try! realm.write {
            //AlarmSettingのidとAlarmItemのalarmSettingIdの共通化（reflectItemDataメソッドで記載済）
            //メイン画面の作業個数(alarmSetting.itemIdCount)とアラームに設定した作業の個数（alarmItemList.count）を共通化
            alarmSetting.itemIdCount = alarmItemList.count
            //項目名の共通化
            alarmSetting.alarmName = alarmStartSettingTimeHeader.alarmNameText.text ?? ""
            print("保存したalarmSetting.alarmNameは\(alarmSetting.alarmName)です")
            //全体の開始時間の共通化(reflectItemDataメソッドで記載済)
            alarmStartSettingTimeHeader.alarmStartDatePickerText.text = "\(alarmSetting.alarmStartSettingTime.formattedTime())"
            print("保存したalarmSetting.alarmStartSettingTimeは\(alarmSetting.alarmStartSettingTime)です")
            //全体終了時間の共通化(reflectItemDataメソッドで記載済)
            
            print("保存したalarmSetting.alarmEndSettingTimeは\(alarmSetting.alarmEndSettingTime)です")
            realm.add(alarmSetting)
        }
        print("alarmSettingの内容は\(alarmSetting)です")
        
    }
    // MARK: - delegateメソッド（AlarmSettingViewCell）
    //削除処理の実装
    func deleteItem(item: AlarmItem) {
        //alarmItemListの配列からインデックス番号に該当する配列を削除
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
        //　idの共通化ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        alarmItem.alarmSettingId = alarmSetting.id
        print("保存されたalarmItem.alarmSettingIdは\(alarmItem.alarmSettingId)です")
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
        var allStartTime: Date
        var itemStartTime: Date
        //alarmItemListが0の場合（項目が追加されていない場合）、ヘッダーの時間を開始時間に反映
        //Date型に変換できなかった場合は、現在時刻を反映
        if alarmItemList.count == 0 {
            //文字列→Date型にするために日付を追加（yyyy/MM/dd HH:mm式でないと認識しないため）
            let dateString = "2023/11/2 " +   alarmStartSettingTimeHeader.alarmStartDatePickerText.text!
            print("alarmStartSettingTimeHeader.alarmStartDatePickerText.textの内容は\(String(describing: alarmStartSettingTimeHeader.alarmStartDatePickerText.text))")
            //全体の開始時間をString型→Date型で定義
            allStartTime = dateFormatter.date(from: dateString) ?? Date()
            //項目別の開始時間をString型→Date型で定義
            itemStartTime = dateFormatter.date(from: dateString) ?? Date()
            print("itemStartTimeの時間は\(allStartTime)")
            //全体の開始時間の共通化
            alarmSetting.alarmStartSettingTime = allStartTime
            print("alarmSetting.alarmStartSettingTimeの時間は\(alarmSetting.alarmStartSettingTime)")
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
        print("modifiedItemEndTimeの時間は\(modifiedItemEndTime)")
        
        //全体の終了時間
        //全体の終了時間プロパティの定義
        var alarmEndTime: Date
        //文字列→Date型にするために日付を追加（yyyy/MM/dd HH:mm式でないと認識しないため）
        let dateEndString = "\(modifiedItemEndTime.toStringWithCurrentLocale())"
        print("dateEndStringの時間は\(dateEndString)")
        //dateEndStringの文字列をDate型に変換
        alarmEndTime = dateFormatter.date(from: dateEndString) ?? Date()
        //alarmEndTimeをalarmItem.byItemEndTimeへ共通化
        alarmEndTime = alarmItem.byItemEndTime
        //alarmItem.byItemEndTimeをalarmSetting.alarmEndSettingTimeへ継承
        alarmSetting.alarmEndSettingTime = alarmItem.byItemEndTime
        print("alarmEndTimeの時間は\(alarmEndTime)")

        //全体の終了時間のテキストへ反映
        endSettingTimeLabel.text = alarmEndTime.formattedTime() 
        print("alarmEndTime.formattedTime() の時間は\(alarmEndTime.formattedTime() )")
        //　時間の実装終了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        //　追加・反映の実装ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        //alarmItemListに新しいalarmItemを追加(追加ボタンを押した際のデータ追加)
        alarmItemList.append(alarmItem)
        //データ反映
        alarmSettingTableView.reloadData()
        //　追加・反映の実装終了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        print("alarmItemListの個数は\(alarmItemList.count)個です")
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
