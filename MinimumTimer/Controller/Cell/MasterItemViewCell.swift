//
//  MasterItemViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/30.
//

import UIKit
import RealmSwift
//delegateを定義
protocol MasterItemViewCellDelegate{}


class MasterItemViewCell: UITableViewCell, UITableViewDelegate {
    //項目に設定した時間を紐付け
    @IBOutlet var UserSetupTimeLabel: UILabel!
    //項目に設定した名前を紐付け
    @IBOutlet var UserSetupNameLabel: UILabel!
    //削除ボタンを紐付け
    @IBOutlet var deleteButton: UIButton!
    //編集ボタンを紐付け
    @IBOutlet var editButton: UIButton!
    
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //indexPath
    var indexPath: IndexPath?
    //項目マスタの定義
    var masterItem: MasterItem?
    //MainAlarmViewCellDelegateを定義（他ファイルで使用するため）
    var delegate: MasterItemViewCellDelegate?
    
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
        setupEditButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //データを渡す設定(ndexPathがnilでない場合に、textLabelのテキストを設定する処理)
    func configure() {
        guard let indexPath = indexPath else { return }
        textLabel?.text = "Row: \(indexPath.row), Section: \(indexPath.section)"
    }
    
    
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    //　編集ボタンの仕様
    func setupEditButton() {
        editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
        
    }

    
}
