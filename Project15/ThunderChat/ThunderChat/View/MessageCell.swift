//
//  MessageCell.swift
//  ThunderChat
//
//  Created by Kurtis Hoang on 4/7/21.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var leftAvatarImage: UIImageView!
    
    //similar to viewDidLoad
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //rounded and adjust based on the height of message
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
