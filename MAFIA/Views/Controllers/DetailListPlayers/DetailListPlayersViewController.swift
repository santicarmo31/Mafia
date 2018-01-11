//
//  DetailListPlayersViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 1/5/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class DetailListPlayersViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars & Constants
    
    private var players: [PlayerMO] = [PlayerMO]()
    private var presenter: DetailListPlayersPresenter!
    private var addPlayerAction: UIAlertAction?
    
    weak var listPlayers: PlayersListMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let setPlayersFromList = (listPlayers?.players), let playersFromList = Array(setPlayersFromList) as? [PlayerMO] {
            players = playersFromList
        }
        self.navigationItem.title = listPlayers?.name
        setupView()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func addPlayer(_ sender: Any) {
        
        let alertController = UIAlertController(title: "ADD_PLAYER_TITLE".localized(), message: "ADD_PLAYER_MESSAGE".localized(), preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.delegate = self
        }
        
        addPlayerAction = UIAlertAction(title: "ADD_PLAYER_ACTION".localized(), style: .default) { (action) in
            let textField = alertController.textFields?.first
            guard let playerName = textField?.text, !playerName.isEmpty else {
                print("No hay ningún texto")
                return
            }
            guard let list = self.listPlayers else {
                print("No existe el nombre de la lista")
                return
            }
            self.presenter.addPlayer(withName: playerName, list: list)
        }
        let cancelButton = UIAlertAction(title: "CANCEL_ACTION".localized(), style: .cancel)
        
        alertController.addAction(addPlayerAction!)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = DetailListPlayersPresenter(view: self)
        // presenter.     En ListPlayersViewController se usaba la función showListPlayers(), la cual no tiene similar en DetailListPlayersPresenter
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateAddButtonState(text: String?) {
        // Disable the Add button if the text field is empty.
        let emptyText = text ?? ""
        addPlayerAction?.isEnabled = !emptyText.isEmpty
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

// MARK: - DetailListPlayersView protocol conformace

extension DetailListPlayersViewController: DetailListPlayersView {
    
    func addNewPlayers(players: [PlayerMO]) { // Lucho puso PlayerMO como arreglo en el presenter, pero para las listas no era arreglo, cómo es?
        if let player = players.last, self.players.filter({ $0 != player }).count == 0 {
            self.players.append(player)
            tableView.reloadData()
        } else {
            print("Ya existe ese jugador o no hay jugadores en la lista")
        }
    }
    
    func deletePlayer(player: PlayerMO, indexPath: IndexPath) {
        players.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
}

// MARK: - TableView DataSource

extension DetailListPlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        return cell
    }
}

// MARK: - TableView Delegate

extension DetailListPlayersViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPlayer = players[indexPath.row]
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { // Use -tableView:trailingSwipeActionsConfigurationForRowAtIndexPath: instead of this method, which will be deprecated in a future release.
        
        return [UITableViewRowAction.init(style: .destructive, title: "DELETE_PLAYER_ACTION".localized(), handler: {[weak self] (_, indexpath) in
            if let strongSelf = self {
                // strongSelf.presenter.deletePlayer(player: strongSelf.players[indexpath.row], list: listPlayers, indexPath: indexpath) // Cómo se incluye la lista en este caso?
            }
        } )]
    }
}

// MARK: - TextField Delegate

extension DetailListPlayersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // DIsable the save button while editing.
        addPlayerAction?.isEnabled = false
    }
}