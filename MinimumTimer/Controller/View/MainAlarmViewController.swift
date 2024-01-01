//
//  ViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/19.
//

import UIKit
import RealmSwift

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
        
        let target = alarmSettingList[indexPath.row].id
        let deleteMainAlarm = realm.objects(AlarmSetting.self).filter("id == %@", target).first
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
        print("alarmSettingList個数は\(alarmSettingList.count)個です2")
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
        //セルの定義
        //アラーム名のテキストデータの定義
        cell.alarmNameLabel.text = String(alarmSetting.alarmName)
        print("項目名は\(alarmSetting.alarmName)です")
        //アラーム開始時間のテキストデータ定義（データ変換(Date→テキスト)）
        let allAlarmStartTime = "\(alarmSetting.alarmStartSettingTime.toStringWithCurrentLocale())"
        cell.alarmStartSettingTimeLabel.text = allAlarmStartTime
        print("開始時間は\(allAlarmStartTime)です")
        //終了予定時間のテキストデータを定義（データ変換(Date→テキスト)）
        let allAlarmEndTime = "\(alarmSetting.alarmEndSettingTime.toStringWithCurrentLocale())"
        cell.alarmEndSettingTimeLabel.text = allAlarmEndTime
        print("終了時間は\(allAlarmEndTime)です")
        //作業個数のテキストデータを定義
        //上記で表示した配列の個数を表示
        cell.byItemLabel.text = "\(alarmSetting.itemIdCount)個"
        print("設定作業の個数は\(alarmSetting.itemIdCount)個です")
        //print("設定作業の個数を表示しているセルは\(String(describing: cell.byItemLabel.text))個と表示されています")
        //デリゲートの登録
        cell.delegate = self
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
        // TODO: ここの記載がまだ
        print("セルがタップされました")
        // Realmのインスタンス化
        let realm = try!Realm()
        //　alarmSettingListのインデックス番号のidをeditTarget定数に取得
        let editTarget = alarmSettingList[indexPath.row].id
        //　targetと同じidを持つRealmデータベース内のデータを検索してeditMainAlarmに格納
        let editMainAlarm = realm.objects(AlarmSetting.self).filter("id == %@", editTarget).first
        //　もしもeditPostがnilでなければ以下を実行
        if editMainAlarm != nil {
            // 画面遷移処理（記載済みのテキストデータが必要？）
            let storyboad = UIStoryboard(name: "AlarmSettingViewController", bundle: nil)
            guard let alarmSettingViewController = storyboad.instantiateInitialViewController() as? AlarmSettingViewController else { return }
            //記載済みのテキストデータを取得
            alarmSettingViewController.alarmSetting = editMainAlarm ?? AlarmSetting()
            present(alarmSettingViewController, animated: true)
            alarmSettingViewController.delegate = self
        }
    }

}

