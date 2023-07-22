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
    @objc dynamic var id: Int = 0
    //アラームに追加した作業項目のユニークID・computed propertyで個数を取得
    @objc dynamic var itemId: Int = 0
    //ユーザーが設定した開始時間（24時間表記）
    @objc dynamic var alarmStartSettingTime: Date = Date()
    //ユーザーが設定した開始時間+各項目の所要時間の合計
    @objc dynamic var alarmEndSettingTime: Date = Date()
    
}
