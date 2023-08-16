//
//  AlarmSettingViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/11.
//

import UIKit
import RealmSwift

class AlarmSettingViewCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var itemEndTimeLabel: UILabel!
    @IBOutlet weak var itemStartTimeLabel: UILabel!
    @IBOutlet weak var userSetupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    //　編集ボタンの仕様
    func setupEditButton() {
            editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
    }
    //　削除ボタンの仕様
    func setupDeleteButton() {
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
    }
    
}