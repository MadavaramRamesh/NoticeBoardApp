//
//  CardTableViewCell.swift
//  NoticeBoardApp
//
//  Created by Ramesh Madavaram on 05/01/21.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

     var cornerRadius: CGFloat = 10
     var shadowOffsetWidth: Int = 0
     var shadowOffsetHeight: Int = 3
     var shadowColor: UIColor? = UIColor.white
     var shadowOpacity: Float = 0.5

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        mainContentView.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        mainContentView.layer.masksToBounds = false
        mainContentView.layer.shadowColor = shadowColor?.cgColor
        mainContentView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        mainContentView.layer.shadowOpacity = shadowOpacity
        mainContentView.layer.shadowPath = shadowPath.cgPath
        mainContentView.layer.borderWidth = 3.0
        mainContentView.layer.borderColor = UIColor.lightGray.cgColor
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
