//
//  AlarmSettingViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/25.
//

import UIKit
import RealmSwift

//delegateを定義
protocol AlarmSettingViewControllerDelegate{}

class AlarmSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        //キャンセルした際に画面遷移元に戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    //終了予定時間表示を紐付け
    @IBOutlet weak var endSettingTimeLabel: UILabel!
    //保存ボタンを紐付け
    @IBOutlet weak var saveButton: UIButton!
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var alarmSettingTableView: UITableView!
    
    //アラーム設定のプロパティ
    var alarmSettingList: [AlarmSetting] = []
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //項目マスタのプロパティ
    var masterItemList: [MasterItem] = []
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //フッタービューの設定
        //footerView.frame = CGRect(x: 0, y: 0, width: alarmSettingTableView.frame.width, height: 100)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        //footerView.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
        footerView.backgroundColor = .black
        
        let footerHeight:CGFloat = 100.0
        footerView.frame.size.height = footerHeight
        footerView.frame.size.width = UIScreen.main.bounds.width
        //フッター内に別のビューを作成
        let footerInnerView = UIView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 40.0))
        footerInnerView.backgroundColor = .yellow
        footerView.addSubview(footerInnerView)
        footerInnerView.center = footerView.center
        //alarmSettingTableViewのtableFooterViewに設定
        alarmSettingTableView.tableFooterView = footerView
        
        
        //ヘッダービューの設定
        //ヘッダービューを定義
        let headerView = AlarmStartSettingTimeHeader()
        //footerView.frame = CGRect(x: 0, y: 0, width: alarmSettingTableView.frame.width, height: 100)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //footerView.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
        headerView.backgroundColor = .green
        
        let feaderHeight:CGFloat = 100.0
        headerView.frame.size.height = feaderHeight
        headerView.frame.size.width = UIScreen.main.bounds.width
        

        //alarmSettingTableViewのtableHeaderViewにヘッダービューを設定
        alarmSettingTableView.tableHeaderView = headerView
    }
    
    func setHeader() -> Void {
        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //ダミーデータ作成
        let startDateString = "08:00"
        //初期値の設定(Date型→String型へ)
        guard let dummyStartDate = dateFormatter.date(from: startDateString) else { return }
        
        let headerPost1 = AlarmSetting(id: nil, itemId: nil, alarmStartSettingTime: startDateString, alarmEndSettingTime: nil)
        //ヘッダービューを定義
        let headerView = AlarmStartSettingTimeHeader()
        
        
        
    }

    
    //ヘッダービューにAlarmStartSettingTimeHeaderを設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //ヘッダーに設定するセルを定義
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "AlarmStartSettingTimeHeader")as! AlarmStartSettingTimeHeader
        //セルの内容を設定
        let alarmSetting = alarmSettingList[indexPath.row]
        
        let headerAlarmView = UIView(frame: .zero)
        headerAlarmView.addSubview(headerCell)
        
        //
        headerCell.alarmStartDatePickerView.text = dateFormatter.string(from: alarmSetting.alarmEndSettingTime)
        
        return headerAlarmView
    }
    
    //tableViewにAlarmSettingViewCellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    //tableViewにAlarmSettingViewCellを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの作成
        let alarmSettingViewCell = tableView.dequeueReusableCell(withIdentifier: "AlarmSettingViewCell", for: indexPath)as! AlarmSettingViewCell
        
        return alarmSettingViewCell
    }
    
}
