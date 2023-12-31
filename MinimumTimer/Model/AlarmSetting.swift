//
//  AlarmSetting.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation
import RealmSwift

//アラーム表示に必要なモデルを定義
class AlarmSetting: Object {
    //追加したアラームのユニークID
    @objc dynamic var id: String = UUID().uuidString
    //アラームに追加した作業項目のユニークID
    @objc dynamic var itemId: [String] = []
    //アラームに追加した作業項目のユニークID・computed propertyで個数を取得
    @objc dynamic var itemIdCount: Int = 0
    //アラーム全体の名前
    @objc dynamic var alarmName: String = ""
    //ユーザーが設定した開始時間（24時間表記）
    @objc dynamic var alarmStartSettingTime: Date = Date()
    //ユーザーが設定した開始時間+各項目の所要時間の合計
    @objc dynamic var alarmEndSettingTime: Date = Date()
    //初期化(Relmを使用する引数Objectもクラスは初期化時にconvinienceをつける)
    convenience init(id: String, itemId: String, itemIdCount: Int, alarmName: String, alarmStartSettingTime: Date, alarmEndSettingTime: Date) {
        self.init()
        self.id = id
        self.itemId = [itemId]
        self.itemIdCount = itemIdCount
        self.alarmName = alarmName
        self.alarmStartSettingTime = alarmStartSettingTime
        self.alarmEndSettingTime = alarmEndSettingTime
    }
    
}
