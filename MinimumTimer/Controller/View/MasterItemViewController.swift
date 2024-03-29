//
//  MasterItemViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/23.
//

import UIKit
import RealmSwift

// MARK: - delegateの定義
//delegateを定義
protocol MasterItemViewControllerDelegate{
    
}
// MARK: - classの定義＋機能追加
class MasterItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MasterItemViewCellDelegate, PopUpViewControllerDelegate {
    
    // MARK: - 紐付け＋ボタンアクション
    //＋ボタンを紐付け
    @IBOutlet weak var popUpButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var masterItemTableView: UITableView!
    //＋ボタンが押された際の処理
    @IBAction func popUpButtonAction(_ sender: UIButton) {
        //Segue接続先へ遷移する処理
        performSegue(withIdentifier: "PopUpSegue", sender: nil)
    }
    //Segueが実行された時に呼ばれる処理（値渡し＝delegate）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpSegue" {
            let popUpVC = segue.destination as! PopUpViewController
            popUpVC.delegate = self //=MasterItemViewController
            //もしIndexPathがあれば（設定済みの項目マスタがあれば）
            if let indexPath = sender as? IndexPath {
                //存在しないindexPathはアクセスしないよう回避
                guard indexPath.row < masterItemList.count else { return }
                //編集モードの場合は編集対象のMasterItemを渡す
                let editMasterItem = masterItemList[indexPath.row]
                    popUpVC.masterItem = editMasterItem
                    } else {
                    //新規作成の場合は新しいMasterItemインスタンスを渡す
                    let newMasterItem = MasterItem()
                    popUpVC.masterItem = newMasterItem
                    
                    }
        }
    }
    
    // MARK: - プロパティ
    //項目設定のプロパティ（配列）
    var masterItemList: [MasterItem] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    
    // MARK: - 初期設定関数
    //初期設定表示用メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //セルの登録
        masterItemTableView.register(UINib(nibName: "MasterItemViewCell", bundle: nil), forCellReuseIdentifier: "MasterItemViewCell")
        //データソースの提供
        masterItemTableView.dataSource = self
        //delegateを登録
        masterItemTableView.delegate = self
        //カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        //変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "HH:mm"
        
        //ホーム画面表示時にボタンの仕様を適用
        configurePopUpButton()
        //項目が表示されるよう処理を実行
        setMasterItem()
    }
    // MARK: - ライフサイクルメソッド追加
    //ライフサイクルメソッド　viewが表示される直前で呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //viewが表示される直前に項目を格納しデータを反映させる
        reflectMasterItem()
    }
    
    // MARK: - delegateメソッド（MasterItemViewCell）
    //削除ボタンの実装内容
    func deleteMasterItem(indexPath: IndexPath) {
        // Realmのインスタンス化
        let realm = try!Realm()
        //masterItemListのインデックス番号のidをdeleteTarget定数に取得
        let deleteTarget = masterItemList[indexPath.row].id
        //targetと同じidを持つRealmデータベース内のデータを検索してdeleteMasterItemに格納
        let deleteMasterItem = realm.objects(MasterItem.self).filter("id == %@", deleteTarget).first
        //　もしもdeleteMasterItemがnilでなければ以下を実行
        if let deleteMasterItem {
            //　reaimの書き込み
            try! realm.write {
                //　deletePostをRealmから削除
                realm.delete(deleteMasterItem)
                
            }
            
        }
        //masterItemListの配列からインデックス番号に該当する配列を削除
        masterItemList.remove(at: indexPath.row)
        //テーブルビューからインデックス番号に該当するセルを削除
        masterItemTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //テーブルビューの再読み込み
        masterItemTableView.reloadData()
        
    }
    //編集ボタンの実装内容
    func editedMasterItem(indexPath: IndexPath) {
        //選択したデータをPopUpViewContrrollerへ引き継ぐ
        performSegue(withIdentifier: "PopUpSegue", sender: indexPath)
        
    }
    
    // MARK: - 追加関数
    //項目を格納しデータを反映させる
    func reflectMasterItem() {
            //項目を格納
            setMasterItem()
            //反映
            masterItemTableView.reloadData()
        
    }
    //項目を格納するためのメソッド
    func setMasterItem() -> Void {
        //Realmをインスタンス化
        let realm = try! Realm()
        //項目を表示する際の条件(項目設定時間の時間の昇順・分の昇順)
        let sortProperties = [
            SortDescriptor(keyPath: "userSetupHourTime", ascending: true),
            SortDescriptor(keyPath: "userSetupMinutesTime", ascending: true)
        ]
        //RealmデータベースからMasterItem情報を取得しidの値で降順にソートする
        let result = realm.objects(MasterItem.self).sorted(by: sortProperties)
        //masterItemListに格納
        masterItemList = Array(result)
        
    }
    
    
    //＋ボタンの仕様
    func configurePopUpButton() {
        popUpButton.layer.cornerRadius = popUpButton.bounds.width / 2
    }
    
    // MARK: - delegateメソッド（TableView関係）
    //tableViewにAlarmSettingViewCellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //masterItemListにある個数分セルを返却
        return masterItemList.count
    }
    //tableViewにMasterItemViewCellを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成
        let masterItemViewCell = tableView.dequeueReusableCell(withIdentifier: "MasterItemViewCell", for: indexPath)as! MasterItemViewCell
        //セルの内容を設定
        let masterItemSetting = masterItemList[indexPath.row]
        //セルの定義
        //セルの項目マスタとmasterItemListの共通化
        masterItemViewCell.masterItem = masterItemSetting
        //項目の作業時間(時間)のテキストデータ定義
        masterItemViewCell.UserSetupHourTimeLabel.text =  "\(Int(masterItemSetting.userSetupHourTime ))"
        //項目の作業時間(分)のテキストデータ定義
        masterItemViewCell.UserSetupMinutesTime.text =  "\(Int(masterItemSetting.userSetupMinutesTime ))"
        //項目の名前のテキストデータの定義
        masterItemViewCell.UserSetupNameLabel.text = masterItemSetting.userSetupName
        //indexpath
        masterItemViewCell.indexPath = indexPath
        //デリゲートの登録
        masterItemViewCell.delegate = self
        
        return masterItemViewCell
    }
    //テーブルビューにセルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    // TODO: 無限スクロールの追加(if文を実行すると追加処理がおかしくなる＝indexPathのせい？)
    //無限スクロール（今後対応予定） 〇〇番目のcellが表示される時に呼びだされるメソッド
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            //記事を格納してる配列の総数が6個以上あり、後ろから5番目の記事が表示される時に追加で記事を取得...予定
//            if indexPath.row == self.masterItemList.count - 5 {
//                // 追加のデータを取得する処理を書く
//                self.masterItemList.append(contentsOf: self.masterItemList)
//                self.masterItemTableView.reloadData()
//                }
            
        }
        
    }
    
    
}
