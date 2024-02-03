//
//  ViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift
import UserNotifications

// MARK: - classの定義＋機能追加
class MainAlarmViewController: UIViewController, UITableViewDelegate, AlarmSettingViewControllerDelegate, MainAlarmViewCellDelegate, UITableViewDataSource {
    
    // MARK: - 紐付け＋ボタンアクション
    //+ボタンタップ時に下記関数を実行させる
    @IBAction func alarmSettingButtonAction(_ sender: UIButton) {
        
        transitionToAlarmSettingView()
    }
    //＋ボタンを紐付け
    @IBOutlet weak var alarmSettingButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var mainAlarmTableView: UITableView!
    
    // MARK: - プロパティ
    //アラーム設定のプロパティ（配列）
    var alarmSettingList: [AlarmSetting] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //ローカル通知許可のクラスのインスタンス化
    let center = UNUserNotificationCenter.current()
    
    // MARK: - 初期設定関数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルを登録
        mainAlarmTableView.register(UINib(nibName: "MainAlarmViewCell", bundle: nil), forCellReuseIdentifier: "MainAlarmViewCell")
        //ホーム画面表示時にボタンの仕様を適用
        configureAlarmSettingButton()
        
        //mainAlarmTableViewのデータソースの提供
        mainAlarmTableView.dataSource = self
        //mainAlarmTableViewのdelegateを登録
        mainAlarmTableView.delegate = self
        
        //AlarmSettingViewControllerのdelegateを登録
        let alarmSettingViewController = AlarmSettingViewController()
        alarmSettingViewController.delegate = self
        
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //ローカル通知の許可
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                //許可を得られた場合の処理
                print("通知の許可を得られました。")
            } else {
                //許可が得られなかった場合の処理
                print("通知の許可が得られませんでした。")
            }
        }
        

    }
    
    // MARK: - 追加関数
    //ライフサイクルメソッド
    //MainAlarmViewControllerが表示される直前に実行される
    override func viewWillAppear(_ animated: Bool) {
        //アラームを整列
        //Realmをインスタンス化
        let realm = try! Realm()
        //RealmデータベースからAlarmSettingというオブジェクトを取得し、"alarmStartSettingTime"というキーパスを基準に昇順でソートされた結果を取得
        let result = realm.objects(AlarmSetting.self).sorted(byKeyPath: "alarmStartSettingTime", ascending: true)
        //resultという結果を配列に変換して、alarmSettingListに代入
        alarmSettingList = Array(result)
        
        
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
    
    
    // MARK: - delegateメソッド（AlarmSettingViewController）
    func arrayMainAlarm() {
        //アラームを整列
        //Realmをインスタンス化
        let realm = try! Realm()
        //RealmデータベースからAlarmSettingというオブジェクトを取得し、"alarmStartSettingTime"というキーパスを基準に昇順でソートされた結果を取得
        let result = realm.objects(AlarmSetting.self).sorted(byKeyPath: "alarmStartSettingTime", ascending: true)
        //resultという結果を配列に変換して、alarmSettingListに代入
        alarmSettingList = Array(result)
        //mainAlarmTableViewの反映更新
        mainAlarmTableView.reloadData()
    }
    
    // MARK: - delegateメソッド（MainAlarmViewCell）
    //全体設定の削除機能
    func deleteMainAlarm(indexPath: IndexPath) {
        //Realmをインスタンス化
        let realm = try! Realm()
        
        let target = alarmSettingList[indexPath.row]
        let deleteMainAlarm = realm.objects(AlarmSetting.self).filter("id == %@", target.id).first
        //もしもdeleteMainAlarmがnilでなければ以下を実行
        if let deleteMainAlarm {
            //Realmの処理
            try! realm .write {
                //deleteMainAlarmをRealmから削除
                realm.delete(deleteMainAlarm)
            }
        }
        //alarmSettingListの配列からindexPathに該当する配列を削除
        alarmSettingList.remove(at: indexPath.row)
        //mainAlarmTableViewからindexPathに該当するセルを削除
        mainAlarmTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //mainAlarmTableViewの再読み込み
        mainAlarmTableView.reloadData()
        
    }
    
    // MARK: - delegateメソッド（TableView関係）
    // TableViewに表示するセルの数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //alarmSettingListにある個数分セルを返却
        return alarmSettingList.count
    }
    
    //tableViewにMainAlarmVeiwCellを作成する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成or再利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainAlarmViewCell", for: indexPath) as! MainAlarmViewCell
        
        //セルの内容を設定
        let alarmSetting = alarmSettingList[indexPath.row]
        //セルの全体設定とalarmSettigListの共通化
        cell.allAlarmSetting = alarmSetting
        //indexpath
        cell.indexPath = indexPath
        
        //デリゲートの登録
        cell.delegate = self
        //セルの定義を行ったデータを参照
        cell.setUp(alarmSetting: alarmSetting)
        
        return cell
    }
    
    //テーブルビューにセルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    //セルがタップされた際にアラーム設定画面に戻る処理(全体設定の編集機能)
    //セルがタップされた際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移先の登録
        let storyboad = UIStoryboard(name: "AlarmSettingViewController", bundle: nil)
        guard let alarmSettingViewController = storyboad.instantiateInitialViewController() as? AlarmSettingViewController else { return }
        //記載済みのデータを取得
        alarmSettingViewController.alarmSetting = alarmSettingList[indexPath.row]
        //delegateの登録
        alarmSettingViewController.delegate = self
        //モダール表示の設定
        alarmSettingViewController.modalPresentationStyle = .fullScreen
        //画面遷移処理
        present(alarmSettingViewController, animated: true)
    }

}

