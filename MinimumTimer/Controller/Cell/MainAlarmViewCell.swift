//
//  MainAlarmViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/30.
//

import UIKit
import RealmSwift
//delegateを定義
protocol MainAlarmViewCellDelegate{}

class MainAlarmViewCell: UITableViewCell {
    //削除ボタンを押した際の処理を紐付け
    @IBAction func deleteButtonAction(_ sender: UIButton) {
    }
    //設定したアラームの総個数を紐付け
    @IBOutlet weak var byItemLabel: UILabel!
    //アラーム終了時間を紐付け
    @IBOutlet weak var alarmEndSettingTimeLabel: UILabel!
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartSettingTimeLabel: UILabel!
    //削除ボタンを紐付け
    @IBOutlet weak var deleteButton: UIButton!
    
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //MainAlarmViewCellDelegateを定義（他ファイルで使用するため）
    var delegate: MainAlarmViewCellDelegate?
    
    
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
        byItemLabel.text = String(alarmSetting.itemId)
        
    }
    
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    
}
