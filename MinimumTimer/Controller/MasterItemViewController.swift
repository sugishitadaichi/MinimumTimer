//
//  MasterItemViewController.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/07/23.
//

import UIKit
import RealmSwift

class MasterItemViewController: UIViewController, MasterItemViewCellDelegate {
    //＋ボタンが押された際の処理
    @IBAction func popUpButtonAction(_ sender: UIButton) {
        //Segue接続先へ遷移する処理
        performSegue(withIdentifier: "PopUpSegue", sender: nil)
        
    }
    //＋ボタンを紐付け
    @IBOutlet weak var popUpButton: UIButton!
    //TableViewを紐付け
    @IBOutlet weak var masterItemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ホーム画面表示時にボタンの仕様を適用
        configurePopUpButton()
    }
    
    //＋ボタンの仕様
    func configurePopUpButton() {
        popUpButton.layer.cornerRadius = popUpButton.bounds.width / 2
    }
    
    
}
