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

class AlarmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AlarmSettingViewCellDelegate {
    
    //キャンセルボタンを押した際の処理
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        //キャンセルした際に画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //終了予定時間表示を紐付け
    @IBOutlet weak var endSettingTimeLabel: UILabel!
    //保存ボタンを紐付け
    @IBOutlet weak var saveButton: UIButton!
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var alarmSettingTableView: UITableView!
    
    //アラーム設定のプロパティ
    var alarmSetting: AlarmSetting = AlarmSetting()
    //項目別アラームのプロパティ
    var alarmItemList: [AlarmItem] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //項目マスタのプロパティ
    var masterItemList: [MasterItem] = []
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()
    //
    var startDateString: String?
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルの登録
        alarmSettingTableView.register(UINib(nibName: "AlarmSettingViewCell", bundle: nil), forCellReuseIdentifier: "AlarmSettingViewCell")
        //データソースの提供
        alarmSettingTableView.dataSource = self
        //delegateを登録
        alarmSettingTableView.delegate = self
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //フッタービューの設定
        //フッタービューのt定義
        let footerHeight:CGFloat = 100.0
        let footerView = ItemSelectedFooter(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: footerHeight))
        
        //alarmSettingTableViewのtableFooterViewにフッタービューを設定
        alarmSettingTableView.tableFooterView = footerView
        
        
        
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
        
    }
    
    //ヘッダーに表示するデータの処理
    func setHeader() -> Void {

        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //MainAlarmViewController classをインスタンス化
        let mainAlarmViewController = MainAlarmViewController()
        //ダミーデータ作成
        let startDateString = mainAlarmViewController.startDateString
        //テキストデータの設定
        
        //初期値の設定(Date型→String型へ)
        guard let dummyStartDate = dateFormatter.date(from: startDateString) else { return }
        
        let headerPost1 = AlarmSetting(id: 0, itemId: 0, alarmStartSettingTime: dummyStartDate, alarmEndSettingTime: dummyStartDate)
        
        alarmSetting = headerPost1
        
    }
    
    //フッターに表示するデータの処理
    func setFooter() -> Void {
        //アイテムマスタをピッカービューに反映させる？(Realm実装時に記載)
    }
    
    //項目別設定を格納するためのメソッド
    func setAlarmItem() -> Void {
        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //ダミーデータ作成1
        let byItemStartTimeString = "07:00"
        let byItemEndTimeString = "07:30"
        //初期値の設定(Date型→String型へ)
        guard let dummyByItemStartTime = dateFormatter.date(from: byItemStartTimeString), let dummyByItemEndTime = dateFormatter.date(from: byItemEndTimeString) else { return }
        
        let alarmSetPost1 = AlarmItem(id: 1, alermSettingId: 1, masterId: 1, byItemStartTime: dummyByItemStartTime, byItemEndTime: dummyByItemEndTime, userSetupName: "朝食", userSetupTime: 30)
        
        alarmItemList.append(alarmSetPost1)
        
        //ダミーデータ作成2
        let byItemStartTimeString2 = "07:30"
        let byItemEndTimeString2 = "07:40"
        //初期値の設定(Date型→String型へ)
        guard let dummyByItemStartTime2 = dateFormatter.date(from: byItemStartTimeString2), let dummyByItemEndTime2 = dateFormatter.date(from: byItemEndTimeString2) else { return }
        
        let alarmSetPost2 = AlarmItem(id: 1, alermSettingId: 1, masterId: 1, byItemStartTime: dummyByItemStartTime2, byItemEndTime: dummyByItemEndTime2, userSetupName: "トイレ", userSetupTime: 10)
        
        alarmItemList.append(alarmSetPost2)


    }


    
    
    //tableViewにAlarmSettingViewCellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //masterItemListにある個数分セルを返却
        return alarmItemList.count
    }
    
    //tableViewにAlarmSettingViewCellを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成
        let alarmSettingViewCell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingViewCell", for: indexPath)as! AlarmSettingViewCell
        
        //セルの内容を設定
        let alarmItemSetting = alarmItemList[indexPath.row]
        //セルの定義
        //項目別開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        alarmSettingViewCell.itemStartTimeLabel.text = dateFormatter.string(from: alarmItemSetting.byItemStartTime)
        //項目別開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        alarmSettingViewCell.itemEndTimeLabel.text = dateFormatter.string(from: alarmItemSetting.byItemEndTime)
        //項目名のテキストデータを定義
        alarmSettingViewCell.userSetupNameLabel.text = String(alarmItemSetting.userSetupName)
        //デリゲートの登録
        alarmSettingViewCell.delegate = self

        
        return alarmSettingViewCell
    }
    
    //テーブルビューにセルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

    
}
