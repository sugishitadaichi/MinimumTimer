//
//  AlarmSettingViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/25.
//

import UIKit
import RealmSwift

//delegateを定義
protocol AlarmSettingViewControllerDelegate{}

class AlarmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AlarmSettingViewCellDelegate, ItemSelectedFooterDelegate {
    
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
        //Realmをインスタンス化
        let realm = try! Realm()
        //保存処理の実装
        try! realm.write {
            //MasterItemのオブジェクトを保存
            realm.add(masterItem)
            //AlarmSettingのオブジェクトを保存
            realm.add(alarmSettingObjects)
            
        }
        //画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var alarmSettingTableView: UITableView!
    
    //アラーム設定のプロパティ
    var alarmSetting: AlarmSetting = AlarmSetting()
    //アラーム設定のプロパティ（配列）
    var alarmSettingList: [AlarmSetting] = []
    //アラーム設定のオブジェクト
    var alarmSettingObjects = AlarmSetting()
    //項目別アラームのプロパティ
    var alarmItemList: [AlarmItem] = []
    //項目設定のプロパティの宣言
    var ASVCSelectedMasterItem: MasterItem?
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //項目マスタのプロパティ
    var masterItemList: [MasterItem] = []
    //AlarmStartSettingTimeHeaderをインスタンス化
    let alarmStartSettingTimeHeader = AlarmStartSettingTimeHeader()
    //項目設定オブジェクトの作成
    var masterItem = MasterItem()
    //項目設定オブジェクトの作成
    var alarmItem = AlarmItem()
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()
    
    
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
        //alarmItemの値の設定
        //footerView.alarmItem = ASVCSelectedMasterItem
        
        //alarmSettingTableViewのtableFooterViewにフッタービューを設定
        alarmSettingTableView.tableFooterView = footerView
        //delegateの設定
        footerView.delegate = self
        
        
        
        //ヘッダービューの設定
        //ヘッダービューを定義
        let headerHeight:CGFloat = 100.0
        let headerView = AlarmStartSettingTimeHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        

        //alarmSettingTableViewのtableHeaderViewにヘッダービューを設定
        alarmSettingTableView.tableHeaderView = headerView
        //setHeaderメソッドを画面が表示される際に実行
        setHeader()
        //pickerTextの初期値を設定
        headerView.alarmStartDatePickerText.text = "00:00"
        //setAlarmItemメソッドを画面が表示される際に実行
        setAlarmItem()
        //全体終了時間を設定
        //alarmItemListの最後の要素からbyItemEndTimeを取得し、endSettingTimeLabel.textにセット
        if let endTime = alarmItemList.last?.byItemEndTime {
            endSettingTimeLabel.text = dateFormatter.string(from: endTime)
        }
        
        
    }
    
    //削除処理の実装
    func deleteItem(indexPath: IndexPath) {
        // Realmのインスタンス化
        let realm = try!Realm()
        //　tweetListのインデックス番号のidをtarget定数に取得
        let deleteItemTarget = alarmItemList[indexPath.row].id
        //　targetと同じidを持つRealmデータベース内のデータを検索してdeletePostに格納
        let deleteItem = realm.objects(AlarmItem.self).filter("id == %@", deleteItemTarget).first
        //　もしもdeleteItemがnilでなければ以下を実行
        if let deleteItem {
            //　reaimの書き込み
            try! realm.write {
                //　deletePostをRealmから削除
                realm.delete(deleteItem)
            }
        }
        //alarmSettingListの配列からインデックス番号に該当する配列を削除
        alarmItemList.remove(at: indexPath.row)
        //デーブルビューからインデックス番号に該当するセルを削除（更新（alarmSettingTableView.reloadData）不要）
        alarmSettingTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    //ヘッダーに表示するデータの処理(フッターは項目追加処理のみのため不要)
    func setHeader() -> Void {

        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換
        dateFormatter.dateFormat = "HH:mm"
        //Realmをインスタンス化
        let realm = try! Realm()
        //アラーム設定を表示する際の条件（時間の昇順）
        let resultAlarmTime = realm.objects(AlarmSetting.self).sorted(byKeyPath: "alarmStartSettingTime", ascending: true)
        //alarmSettingListに格納
        alarmSettingList = Array(resultAlarmTime)
        
    }
    
    
    
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
    
    func reflectItemEndTime(selectedMasterItem: MasterItem) {
        //day（現在時刻）を設定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        //項目マスタをアラーム時間と足し合わせる
        //（１項目＝アラーム時間+項目設定時間　２項目目以降＝アラーム時間＋1項目目の項目設置時間+2項目目の項目設置時間...）
            //入力された日付文字列をNSDateオブジェクトに変換し、startTimeに代入
            if let startTime = dateFormatter.date(from: alarmStartSettingTimeHeader.alarmStartDatePickerText.text!){
                //時間を足し合わせる設定(時間+分)
                var modifiedItemEndTime = Calendar.current.date(byAdding: .hour, value: masterItem.userSetupHourTime, to: startTime)! + Calendar.current.date(byAdding: .minute, value: masterItem.userSetupMinutesTime, to: startTime)!.timeIntervalSinceReferenceDate
                //テキスト・alarmSettingモデル・合計時間の共通化
                alarmItem.byItemEndTime = modifiedItemEndTime
                modifiedItemEndTime = alarmSetting.alarmEndSettingTime
            }
        //反映
        alarmSettingTableView.reloadData()
        
    }
    //項目別の終了予定時間を格納しデータを反映させる（不要？要検討）
    func reflectItemEndTime() {
        //項目別設定を格納
        setAlarmItem()
        //反映
        alarmSettingTableView.reloadData()
    }


    
    
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
        //masterItemList[row] を選択されたマスタ情報として ASVCselectedMasterItem にも代入する
        //ASVCSelectedMasterItem = masterItemList[indexPath.row]
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
