//
//  PopUpViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/31.
//

import Foundation
import RealmSwift

class PopUpViewController: UIViewController {
    @IBAction func cancelButtonAction(_ sender: Any) {
        //キャンセルすると画面を戻る処理
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userSetupTimeText: UITextField!
    @IBOutlet weak var userSetupNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ポップアップの背景色を設定
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
}
