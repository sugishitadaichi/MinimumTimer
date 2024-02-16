//
//  MainAlarmViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/30.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
//delegateを定義
protocol MainAlarmViewCellDelegate{
    func deleteMainAlarm(indexPath: IndexPath)
}
// MARK: - classの定義＋機能追加
class MainAlarmViewCell: UITableViewCell {
    
    
    // MARK: - 紐付け＋ボタンアクション
    //ON・OFFボタンの分岐処理
    @IBAction func AlarmUISwitchAction(_ sender: UISwitch) {
        //通知送信機能のclassをインスタンス化
        let center = UNUserNotificationCenter.current()
        //ローカル通知内容のクラスのインスタンス化
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        //スイッチがONであれば
        if ( sender.isOn ) {
            print("スイッチがONになりました")
            //通知音
            content.sound = UNNotificationSound.default
            // MARK: 通知をいつ発動するかを設定
            // カレンダークラスを作成
            let calendar: Calendar = Calendar.current
            //alarmItemListのデータを使用のためfor in関数を使用
            for alarmItemListData in alarmItemList {
                //通知タイトル
                content.title = "アラーム名：\(allAlarmSetting?.alarmName ?? "")        作業名：\(alarmItemListData.userSetupName)"
                //alarmItemListに格納されてある作業別開始時間ごとにアラームが鳴る
                let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.hour, .minute], from:alarmItemListData.byItemStartTime ), repeats: false)
                // MARK: 通知のリクエストを作成
                let request: UNNotificationRequest = UNNotificationRequest(identifier: alarmItemListData.id, content: content, trigger: trigger)
                // MARK: 通知のリクエストを実際に登録する
                UNUserNotificationCenter.current().add(request) { (error: Error?) in
                    // エラーが存在しているかをif文で確認している
                    if error != nil {
                        // MARK: エラーが存在しているので、エラー内容をprintする
                        print("通知がうまくいきませんでした。")
                    } else {
                        // MARK: エラーがないので、うまく通知を追加できた
                        print("通知に成功しました。")
                    }
                }
                //通知予定の一覧確認
                center.getPendingNotificationRequests {requests in
                    requests.forEach {
                        debugPrint($0.description)
                    }
                }
            }
            
        } else {
            //スイッチがOFFであれば
            print("スイッチがOFFになりました")
            //登録された通知のうち任意のもの(alarmItemListData.id)を1つだけ削除
            for alarmItemListData in alarmItemList {
            center.removePendingNotificationRequests(withIdentifiers: [alarmItemListData.id])
            }
        }
    }
    //削除ボタンを押した際の処理を紐付け
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        //delegateの設定
        delegate?.deleteMainAlarm(indexPath: indexPath!)
        
        //通知の削除処理
        //通知送信機能のclassをインスタンス化
        let center = UNUserNotificationCenter.current()
        //登録された通知のうち任意のもの(alarmItemListData.id)を1つだけ削除
        for alarmItemListData in alarmItemList {
            center.removePendingNotificationRequests(withIdentifiers: [alarmItemListData.id])
        }
    }
    //設定したアラームの名前を紐付け
    @IBOutlet weak var alarmNameLabel: UILabel!
    //設定したアラームの総個数を紐付け
    @IBOutlet weak var byItemLabel: UILabel!
    //アラーム終了時間を紐付け
    @IBOutlet weak var alarmEndSettingTimeLabel: UILabel!
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartSettingTimeLabel: UILabel!
    //削除ボタンを紐付け
    @IBOutlet weak var deleteButton: UIButton!
    //ON・OFFボタンの紐付け
    @IBOutlet weak var AlarmUISwitch: UISwitch!
    
    // MARK: - プロパティ
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //全体設定の定義(型をAlarmSettingモデルに設定)
    var allAlarmSetting: AlarmSetting?
    //MainAlarmViewCellDelegateを定義（他ファイルで使用するため）
    var delegate: MainAlarmViewCellDelegate?
    //AlarmItemの配列のプロパティ
    var alarmItemList = [AlarmItem]()
    //IndexPath
    var indexPath: IndexPath?
    
    // MARK: - 初期設定関数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        //画面表示時に角丸を実装
        setupDeleteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUp(alarmSetting: AlarmSetting) {
        //引数alarmSettingをallAlarmSettingに設定
        allAlarmSetting = alarmSetting
        // Realm から alarmSetting に基づいて mavcAlarmItemListData を取得
        if let realm = try? Realm() {
            let mavcAlarmItemListData = realm.objects(AlarmItem.self).filter("alarmSettingId == %@" , alarmSetting.id)
            // 結果が空でないか確認してから alarmItemList に設定
                if !mavcAlarmItemListData.isEmpty {
                    alarmItemList = Array(mavcAlarmItemListData)
                }
            
        }
        //アラーム名のテキストデータの定義
        alarmNameLabel.text = String(alarmSetting.alarmName)
        //アラーム開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        alarmStartSettingTimeLabel.text = dateFormatter.string(from: alarmSetting.alarmStartSettingTime)
        //終了予定時間のテキストデータを定義（データ変換(Date→テキスト)）
        alarmEndSettingTimeLabel.text = dateFormatter.string(from: alarmSetting.alarmEndSettingTime)
        //作業個数のテキストデータを定義
        byItemLabel.text = "\(alarmSetting.itemIdCount)個"

    }
    // MARK: - 追加関数
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    
}
