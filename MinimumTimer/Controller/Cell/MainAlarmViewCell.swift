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
    //削除ボタンを押した際の処理を紐付け
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        //delegateの設定
        delegate?.deleteMainAlarm(indexPath: indexPath!)
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
    
    // MARK: - プロパティ
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //全体設定の定義(型をAlarmSettingモデルに設定)
    var allAlarmSetting: AlarmSetting?
    //MainAlarmViewCellDelegateを定義（他ファイルで使用するため）
    var delegate: MainAlarmViewCellDelegate?
    //AlarmSettingの配列のプロパティ
    var alarmSettingList: [AlarmSetting] = []
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
// MARK: - 追加機能
extension MainAlarmViewCell: UITableViewDelegate,AlarmSettingViewControllerDelegate {
    func arrayMainAlarm() {
        //無記載
    }
    
    //セルがタップされた際にアラーム設定画面に戻る処理
    //セルがタップされた際の処理
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // TODO: ここの記載がまだ
//        // Realmのインスタンス化
//        let realm = try!Realm()
//        //　alarmSettingListのインデックス番号のidをeditTarget定数に取得
//        let editTarget = alarmSettingList[indexPath.row].id
//        //　targetと同じidを持つRealmデータベース内のデータを検索してeditPostに格納
//        let editMainAlarm = realm.objects(AlarmSetting.self).filter("id == %@", editTarget).first
//        //　もしもeditPostがnilでなければ以下を実行
//        if editMainAlarm != nil {
//            // 画面遷移処理（記載済みのテキストデータが必要？）
//            let storyboad = UIStoryboard(name: "AlarmSettingViewController", bundle: nil)
//            guard let alarmSettingViewController = storyboad.instantiateInitialViewController() as? AlarmSettingViewController else { return }
//            //記載済みのテキストデータを取得
//            editorViewController.tweet = editMainAlarm ?? AlarmSetting()
//            present(alarmSettingViewController, animated: true)
//            alarmSettingViewController.delegate = self
//        }
//    }
}
