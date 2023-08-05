//
//  MainAlarmViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/30.
//

import UIKit
import RealmSwift
//delegateを定義
protocol MasterItemViewCellDelegate{}

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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "H:mm"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(alarmSetting: AlarmSetting) {
        //データ変換(Date→テキスト)
        alarmEndSettingTimeLabel.text = dateFormatter.string(from: Date())
        //終了予定時間のモデルを定義
        alarmEndSettingTimeLabel.text = alarmSetting.alarmEndSettingTime
        
    }
    
}
