//
//  AlarmSettingViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/11.
//

import UIKit
import RealmSwift
//delegateを定義
protocol AlarmSettingViewCellDelegate{}


class AlarmSettingViewCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemEndTimeLabel: UILabel!
    @IBOutlet weak var itemStartTimeLabel: UILabel!
    @IBOutlet weak var userSetupNameLabel: UILabel!
    //delegateの設定
    var delegate: AlarmSettingViewCellDelegate?
    //項目マスタの定義
    var alarmItem: AlarmItem?
    //indexPath
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //画面表示時に角丸を実装
        setupDeleteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    
}
