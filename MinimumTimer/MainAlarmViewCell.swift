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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(alarmSetting: AlarmSetting) {
        
        //alarmEndSettingTimeLabel.text = alarmSetting.alarmEndSettingTime
        
    }
    
}
