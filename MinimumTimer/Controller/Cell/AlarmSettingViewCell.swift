//
//  AlarmSettingViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/11.
//

import UIKit
import RealmSwift
// MARK: - delegateの定義
//delegateを定義
protocol AlarmSettingViewCellDelegate{
    func deleteItem(item: AlarmItem)
}

// MARK: - classの定義＋機能追加
class AlarmSettingViewCell: UITableViewCell {
    // MARK: - 紐付け＋ボタンアクション
    //削除ボタンを押した時の処理
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        //削除処理を受ける処理
        delegate?.deleteItem(item: alarmItem!)
    }
    //削除ボタンを紐付け
    @IBOutlet weak var deleteButton: UIButton!
    //項目別終了時間を紐付け
    @IBOutlet weak var itemEndTimeLabel: UILabel!
    //項目別開始時間を紐付け
    @IBOutlet weak var itemStartTimeLabel: UILabel!
    //項目名を紐付け
    @IBOutlet weak var userSetupNameLabel: UILabel!
    
    // MARK: - プロパティ
    //delegateの設定
    var delegate: AlarmSettingViewCellDelegate?
    //項目マスタの定義
    var alarmItem: AlarmItem?
    //indexPath
    var indexPath: IndexPath?
    
    // MARK: - 初期設定関数
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
    
    // MARK: - 追加関数
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    
}
