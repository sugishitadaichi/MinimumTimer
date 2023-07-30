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
        //テキストの定義
        var popUpTextField: UITextField?
        
        let masterItemViewCell = MasterItemViewCell()
        
        let popUptext = UIAlertController(
            title: "項目名（10文字以内）", message: "", preferredStyle: UIAlertController.Style.alert)
        
        popUptext.addTextField(
            configurationHandler: {(textField: UITextField!) in
                popUpTextField = textField
                textField.text = masterItemViewCell.UserSetupNameLabel.text
            })
        
        
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
