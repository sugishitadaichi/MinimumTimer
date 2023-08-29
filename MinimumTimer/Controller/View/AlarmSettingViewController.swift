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
    var alarmSetting: AlarmSetting = AlarmSetting()
    //DateFormatterクラスのインスタンス化
    let dateFormatter = DateFormatter()
    //項目マスタのプロパティ
    var masterItemList: [MasterItem] = []
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()
    //
    var startDateString: String?

    
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
        let headerHeight:CGFloat = 100.0
        let headerView = AlarmStartSettingTimeHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        //footerView.frame = CGRect(x: 0, y: 0, width: alarmSettingTableView.frame.width, height: 100)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerView.frame.size.height = headerHeight
        headerView.frame.size.width = UIScreen.main.bounds.width
        

        //alarmSettingTableViewのtableHeaderViewにヘッダービューを設定
        alarmSettingTableView.tableHeaderView = headerView
        //setHeaderメソッドを画面が表示される際に実行
        setHeader()
        
        headerView.alarmStartDatePickerText.text = "00:00"
    }
    
    func setHeader() -> Void {

        //dateFormatterを定義
        let dateFormatter = DateFormatter()
        //Date型への変換？
        dateFormatter.dateFormat = "HH:mm"
        //MainAlarmViewController classをインスタンス化
        let mainAlarmViewController = MainAlarmViewController()
        //ダミーデータ作成
        let startDateString = mainAlarmViewController.startDateString
        //テキストデータの設定
        
        //初期値の設定(Date型→String型へ)
        guard let dummyStartDate = dateFormatter.date(from: startDateString) else { return }
        
        let headerPost1 = AlarmSetting(id: 0, itemId: 0, alarmStartSettingTime: dummyStartDate, alarmEndSettingTime: dummyStartDate)
        
        alarmSetting = headerPost1
        
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
