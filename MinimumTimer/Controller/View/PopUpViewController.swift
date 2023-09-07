//
//  PopUpViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/31.
//

import Foundation
import RealmSwift

class PopUpViewController: UIViewController {
    //ユーザーが項目に設定した時間（分）を紐付け
    @IBOutlet weak var userSetupMinutesTimeText: UITextField!
    //ユーザーが項目に設定した時間（時間）を紐付け
    @IBOutlet weak var userSetupHourTimeText: UITextField!
    //キャンセルボタンを押した際の処理を紐付け
    @IBAction func cancelButtonAction(_ sender: Any) {
        //キャンセルすると画面を戻る処理
        dismiss(animated: true, completion: nil)
    }
    //キャンセルボタンを紐付け
    @IBOutlet weak var cancelButton: UIButton!
    //追加ボタンを紐付け
    @IBOutlet weak var addButton: UIButton!
    //ユーザーが追加した項目名を紐付け
    @IBOutlet weak var userSetupNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ポップアップの背景色を設定
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
}
