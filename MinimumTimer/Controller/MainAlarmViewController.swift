//
//  ViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift

class MainAlarmViewController: UIViewController, UITableViewDelegate, AlarmSettingViewControllerDelegate, MainAlarmViewCellDelegate, UITableViewDataSource {
    @IBAction func alarmSettingButtonAction(_ sender: UIButton) {
        //+ボタンタップ時に下記関数を実行させる
        transitionToAlarmSettingView()
    }
    //＋ボタンを紐付け
    @IBOutlet weak var alarmSettingButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var mainAlarmTableView: UITableView!
    
    //アラーム設定のプロパティ
    var alarmSettingList: [AlarmSetting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルを登録
        mainAlarmTableView.register(UINib(nibName: "MainAlarmViewCell", bundle: nil), forCellReuseIdentifier: "MainAlarmViewCell")
        //ホーム画面表示時にボタンの仕様を適用
        configureAlarmSettingButton()
        
        mainAlarmTableView.dataSource = self
    }
    
    //＋ボタンの仕様
    func configureAlarmSettingButton() {
        alarmSettingButton.layer.cornerRadius = alarmSettingButton.bounds.width / 2
    }
    
    //　＋ボタンがタップされた際に画面遷移する処理
    func transitionToAlarmSettingView() {
        //遷移するstoryboardを定義
        let storyboard = UIStoryboard(name: "AlarmSettingViewController", bundle: nil)
        guard let asvc = storyboard.instantiateViewController(withIdentifier: "AlarmSettingViewController") as? AlarmSettingViewController else { return }
        //モダール表示の設定
        asvc.modalPresentationStyle = .fullScreen
        //画面遷移(モーダル遷移)
        present(asvc, animated: true)
        //delegateの設定
        asvc.delegate = self
    }
    
    // TableViewに表示するセルの数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        //ダミー完了後はreturn alarmSettingList.count
    }
    
    //テーブルビューにセルを作成する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成or再利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainAlarmViewCell", for: indexPath) as! MainAlarmViewCell
        
        //セルの内容を設定
        let alarmSetting = alarmSettingList[indexPath.row]
        //ダミーデータ作成
        cell.alarmStartSettingTimeLabel.text = "8:00"
        cell.alarmEndSettingTimeLabel.text = "9:00"
        cell.byItemLabel.text = "5"
        //デリゲートの登録
        cell.delegate = self
        cell.setUp(alarmSetting: alarmSetting)
        
        return cell
    }


}

