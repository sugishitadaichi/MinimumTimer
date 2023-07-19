//
//  AlarmSetting.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation

//アラーム表示に必要なモデルを定義
struct AlarmSetting {
    //追加したアラームのユニークID
    var id: Int
    //アラームに追加した作業項目のユニークID・computed propertyで個数を取得
    var ItemId: Int
    //ユーザーが設定した開始時間（24時間表記）
    var alarmStartSettingTime: Date
    //ユーザーが設定した開始時間+各項目の所要時間の合計
    var alarmEndSettingTime: Date
    
}
