//
//  AlarmItem.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation

//アラーム内容の設定に必要なモデルを定義
class AlarmItem {
    //アラームに追加した作業項目のユニークID（AlarmSettingモデルのItemIdと同義）
    var id: Int = 0
    //紐づくアラームAlarmSettingのユニークID（AlarmSettingモデルのidと同義）
    var alermSettingId: Int = 0
    //マスタに追加した作業項目のユニークID
    var MasterId: Int = 0
    //項目別の作業開始時間
    var byItemStartTime: Date = Date()
    //AlarmSetting.作業開始時間+AlarmSetup.設定した時間(作業終了時間)
    var byItemEndTime: Date = Date()
    //ユーザーが設定した項目名
    var userSetupName: String = ""
    //ユーザーが項目に設定した時間
    var userSetupTime: Int = 0
}
