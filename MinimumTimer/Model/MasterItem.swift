//
//  MasterItem.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation

//アラームの項目設定に必要なモデルを定義
struct MasterItem {
    //マスタに追加した作業項目のユニークID(AlarmItemモデルのMasterIdと同義)
    var id: Int
    //ユーザーが設定した項目名
    var userSetupName: String
    //ユーザーが項目に設定した時間
    var userSetupTime: Int
}
