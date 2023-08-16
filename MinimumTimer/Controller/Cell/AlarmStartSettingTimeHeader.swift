//
//  AlarmStartSettingTimeViewCell.swift
//  MinimumTimer
//
//  Created by 杉下大智 on 2023/08/05.
//

import UIKit

class AlarmStartSettingTimeHeader: UIView {
    //アラーム開始時間を紐付け
    @IBOutlet weak var alarmStartDatePickerView: UIDatePicker!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
    //initの実装
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    
}
