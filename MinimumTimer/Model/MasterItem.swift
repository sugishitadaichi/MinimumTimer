//
//  MasterItem.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import Foundation
import RealmSwift

//アラームの項目設定に必要なモデルを定義
class MasterItem: Object {
    //マスタに追加した作業項目のユニークID(AlarmItemモデルのMasterIdと同義)
    @objc dynamic var id: Int = 0
    //ユーザーが設定した項目名
    @objc dynamic var userSetupName: String = ""
    //ユーザーが項目に設定した時間
    @objc dynamic var userSetupTime: Date = Date()
    
    //初期化(Relmを使用する引数Objectもクラスは初期化時にconvinienceをつける)
    convenience init(id: Int, userSetupName: String, userSetupTime: Date) {
        self.init()
        self.id = id
        self.userSetupName = userSetupName
        self.userSetupTime = userSetupTime
    }
}
