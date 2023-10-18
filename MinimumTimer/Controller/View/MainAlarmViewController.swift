//
//  ViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift

// MARK: - classの定義＋機能追加
class MainAlarmViewController: UIViewController, UITableViewDelegate, AlarmSettingViewControllerDelegate, MainAlarmViewCellDelegate, UITableViewDataSource {
    
    // MARK: - 紐付け＋ボタンアクション
    //+ボタンタップ時に下記関数を実行させる
    @IBAction func alarmSettingButtonAction(_ sender: UIButton) {
        
        transitionToAlarmSettingView()
    }
    //＋ボタンを紐付け
    @IBOutlet weak var alarmSettingButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var mainAlarmTableView: UITableView!
    
    // MARK: - プロパティ
    let startDateString = "08:00"
    //アラーム設定のプロパティ（配列）
    var alarmSettingList: [AlarmSetting] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    
    // MARK: - 初期設定関数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルを登録
        mainAlarmTableView.register(UINib(nibName: "MainAlarmViewCell", bundle: nil), forCellReuseIdentifier: "MainAlarmViewCell")
        //ホーム画面表示時にボタンの仕様を適用
        configureAlarmSettingButton()
        
        //データソースの提供
        mainAlarmTableView.dataSource = self
        //delegateを登録
        mainAlarmTableView.delegate = self
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //アラームセルを表示する処理を実行
        setMainAlarm()
    }
    
    // MARK: - 追加関数
    //＋ボタンの仕様
    func configureAlarmSettingButton() {
        alarmSettingButton.layer.cornerRadius = alarmSettingButton.bounds.width / 2
    }
    
    //　＋ボタンがタップされた際に画面遷移する処理
    func transitionToAlarmSettingView() {
        //遷移するstoryboardを定義
        let storyboard = UIStoryboard(name: "AlarmSettingViewController", bundle: nil)
        guard let asvc = storyboard.instantiateViewController(withIdentifier: "AlarmSettingViewController") as? AlarmSettingViewController else { return }
        //モダール表示の設定
        asvc.modalPresentationStyle = .fullScreen
        //画面遷移(モーダル遷移)
        present(asvc, animated: true)
        //delegateの設定
        asvc.delegate = self
    }
    
    //アラームを格納するためのメソッド
    func setMainAlarm() -> Void {
        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //ダミーデータ作成
        let startDateString = "08:00"
        let endDateString = "09:00"
        //初期値の設定(Date型→String型へ)
        guard let dummyStartDate = dateFormatter.date(from: startDateString), let dummyEndDate = dateFormatter.date(from: endDateString) else { return }
        
        let alarmPost1 = AlarmSetting(id: "1", itemId: "1", alarmStartSettingTime: dummyStartDate, alarmEndSettingTime: dummyEndDate)
        
        alarmSettingList.append(alarmPost1)
    }
    
    // MARK: - delegateメソッド（TableView関係）
    // TableViewに表示するセルの数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //alarmSettingListにある個数分セルを返却
        return alarmSettingList.count
    }
    
    //tableViewにMainAlarmVeiwCellを作成する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成or再利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainAlarmViewCell", for: indexPath) as! MainAlarmViewCell
        
        //セルの内容を設定
        let alarmSetting = alarmSettingList[indexPath.row]
        //セルの定義
        //アラーム開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        cell.alarmStartSettingTimeLabel.text = dateFormatter.string(from: alarmSetting.alarmStartSettingTime)
        //終了予定時間のテキストデータを定義（データ変換(Date→テキスト)）
        cell.alarmEndSettingTimeLabel.text = dateFormatter.string(from: alarmSetting.alarmEndSettingTime)
        //作業個数のテキストデータを定義
        cell.byItemLabel.text = String(alarmSetting.itemId)
        //デリゲートの登録
        cell.delegate = self
        cell.setUp(alarmSetting: alarmSetting)
        
        return cell
    }
    
    //テーブルビューにセルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }


}

