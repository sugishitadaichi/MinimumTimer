//
//  ViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift

class MainAlarmViewController: UIViewController {
    //＋ボタンを紐付け
    @IBOutlet weak var alarmSettingButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var mainAlarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ホーム画面表示時にボタンの仕様を適用
        configureAlarmSettingButton()
    }
    
    //＋ボタンの仕様
    func configureAlarmSettingButton() {
        alarmSettingButton.layer.cornerRadius = alarmSettingButton.bounds.width / 2
    }


}

