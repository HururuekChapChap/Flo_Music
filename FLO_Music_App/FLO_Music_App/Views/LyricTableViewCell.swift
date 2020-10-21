//
//  LyricTableViewCell.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/21.
//

import UIKit

//5일차
class LyricTableViewCell: UITableViewCell {

    @IBOutlet weak var lyricLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLyricLable(word : String){
        lyricLabel.text = word
    }
    
    func changeLyricLableUI(color : UIColor){
        lyricLabel.textColor = color
    }
    
    override func prepareForReuse() {
        lyricLabel.textColor = UIColor.black
    }
    

}
