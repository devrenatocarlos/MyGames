//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by aluno on 27/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

        @IBOutlet weak var ivCover: UIImageView!
        @IBOutlet weak var lbTitle: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        func prepare(with console: Console) {
            lbTitle.text = console.name ?? ""
            //lbConsole.text = console.console?.name ?? ""
            if let image = console.cover as? UIImage {
                ivCover.image = image
            } else {
                ivCover.image = UIImage(named: "noCover")
            }
        }
    }
