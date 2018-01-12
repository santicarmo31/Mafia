//
//  PlayersListTableViewCell.swift
//  MAFIA
//
//  Created by Hugo Bernal on Jan/12/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol PlayersListTableViewCellDelegate {
    func startGame(withList list: PlayersListMO) -> Void
}

class PlayersListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playersListForGameButton: UIButton!
    var list: PlayersListMO?
    var delegate: PlayersListTableViewCellDelegate?
    
    // MARK: - IBActions
    
    @IBAction func usePlayersListForGameButton(_ sender: Any) {
        if let list = list {
            delegate?.startGame(withList: list)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playersListForGameButton.setTitle("USE_PLAYERS_LIST_BUTTON_TITLE".localized(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Methods
    
    func setCellData(list: PlayersListMO) {
        self.list = list
        nameLabel.text = list.name
    }
    
}