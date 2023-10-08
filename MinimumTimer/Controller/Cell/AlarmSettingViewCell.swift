//
//  AlarmSettingViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/11.
//

import UIKit
import RealmSwift
//delegateを定義
protocol AlarmSettingViewCellDelegate{
    func deleteItem(indexPath: IndexPath)
}


class AlarmSettingViewCell: UITableViewCell {
    //削除ボタンを押した時の処理
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        //削除処理を受ける処理
        delegate?.deleteItem(indexPath: indexPath!)
    }
    //削除ボタンを紐付け
    @IBOutlet weak var deleteButton: UIButton!
    //項目別終了時間を紐付け
    @IBOutlet weak var itemEndTimeLabel: UILabel!
    //項目別開始時間を紐付け
    @IBOutlet weak var itemStartTimeLabel: UILabel!
    //項目名を紐付け
    @IBOutlet weak var userSetupNameLabel: UILabel!
    //delegateの設定
    var delegate: AlarmSettingViewCellDelegate?
    //項目マスタの定義
    var alarmItem: AlarmItem?
    var masterItem: MasterItem?
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
