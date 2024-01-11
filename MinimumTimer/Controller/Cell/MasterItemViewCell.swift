//
//  MasterItemViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/30.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
//delegateを定義
protocol MasterItemViewCellDelegate{
    func deleteMasterItem(indexPath: IndexPath)
    func editedMasterItem(indexPath: IndexPath)
}

// MARK: - classの定義＋機能追加
class MasterItemViewCell: UITableViewCell, UITableViewDelegate {
    //項目に設定した名前を紐付け
    @IBOutlet weak var UserSetupNameLabel: UILabel!
    //項目に設定した時間(時間)を紐付け
    @IBOutlet weak var UserSetupHourTimeLabel: UITextField!
    //項目に設定した時間(分)を紐付け
    @IBOutlet weak var UserSetupMinutesTime: UITextField!
    //削除ボタンを紐付け
    @IBOutlet var deleteButton: UIButton!
    //削除ボタンを押した際の処理
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        //処理はMasterItemViewControllerで行う
        delegate?.deleteMasterItem(indexPath: indexPath!)
    }

    //編集ボタンを紐付け
    @IBOutlet var editButton: UIButton!
    //編集ボタンを押した際の処理
    @IBAction func editButtonActtion( _ sender: UIButton) {
        //処理はMasterItemViewControllerで行う
        delegate?.editedMasterItem(indexPath: indexPath!)
        
    }
    
    // MARK: - プロパティ
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //indexPath
    var indexPath: IndexPath?
    //項目マスタの定義
    var masterItem: MasterItem?
    //MainAlarmViewCellDelegateを定義（他ファイルで使用するため）
    var delegate: MasterItemViewCellDelegate?
    
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
        setupEditButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - 追加関数
    //データを渡す設定(indexPathがnilでない場合に、textLabelのテキストを設定する処理)
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
