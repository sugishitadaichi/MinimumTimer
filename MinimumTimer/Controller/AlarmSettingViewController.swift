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

class AlarmSettingViewController: UIViewController {
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
        //footerView.frame = CGRect(x: 0, y: 0, width: alarmSettingTableView.frame.width, height: 100)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //footerView.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
        headerView.backgroundColor = .green
        
        let feaderHeight:CGFloat = 100.0
        headerView.frame.size.height = feaderHeight
        headerView.frame.size.width = UIScreen.main.bounds.width
        //alarmSettingTableViewのtableHeaderViewに設定
        alarmSettingTableView.tableHeaderView = headerView
    }
    //delegateの設定
    var delegate: AlarmSettingViewControllerDelegate?
    //フッタービューを定義
    let footerView = UIView()
    //ヘッダービューを定義
    let headerView = UIView()
    
}
