//
//  MasterItem.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift

//アラームの項目設定に必要なモデルを定義
class MasterItem: Object {
    //マスタに追加した作業項目のユニークID(AlarmItemモデルのMasterIdと同義)
    @objc dynamic var id: String = UUID().uuidString
    //ユーザーが設定した項目名
    @objc dynamic var userSetupName: String = ""
    //項目を設定した日付・時間の管理
    var recordDate: Date = Date()
    //ユーザーが項目に設定した時間（時間）
    @objc dynamic var userSetupHourTime: Int = 0
    //ユーザーが項目に設定した時間（分）
    @objc dynamic var userSetupMinutesTime: Int = 0
    
    //初期化(Relmを使用する引数Objectもクラスは初期化時にconvinienceをつける)
    convenience init(id: String, userSetupName: String, recordDate: Date, userSetupHourTime: Int, userSetupMinutesTime: Int) {
        self.init()
        self.id = id
        self.userSetupName = userSetupName
        self.recordDate = recordDate
        self.userSetupHourTime = userSetupHourTime
        self.userSetupMinutesTime = userSetupMinutesTime
    }
}
