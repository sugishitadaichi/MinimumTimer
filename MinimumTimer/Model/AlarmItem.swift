//
//  AlarmItem.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation
import RealmSwift

//アラーム内容の設定に必要なモデルを定義
class AlarmItem: Object {
    //アラーム全体のユニークID（AlarmSettingモデルのidと同義）
    @objc dynamic var alarmSettingId: String = UUID().uuidString
    //アラームに追加した作業項目のユニークID（AlarmSettingモデルのItemIdと同義）
    @objc dynamic var id: String = UUID().uuidString
    //マスタに追加した作業項目のユニークID
    @objc dynamic var masterId: String = UUID().uuidString
    //項目別の作業開始時間
    @objc dynamic var byItemStartTime: Date = Date()
    //AlarmSetting.作業開始時間+AlarmSetup.設定した時間(作業終了時間)
    @objc dynamic var byItemEndTime: Date = Date()
    //作業終了時間 - 作業開始時間の差分
    var byItemDifferentTime: Double {
        return -1 * byItemEndTime.timeIntervalSince(byItemStartTime)
    }
    //ユーザーが設定した項目名
    @objc dynamic var userSetupName: String = ""
    
    //初期化(Realmを使用する引数Objectもクラスは初期化時にconvinienceをつける)
    convenience init(alarmSettingId: String, userSetupName: String) {
        self.init()
        self.alarmSettingId = alarmSettingId
        self.userSetupName = userSetupName
    }
    
    //プライマリキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }

}
