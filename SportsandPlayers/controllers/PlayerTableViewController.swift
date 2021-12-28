//
//  PlayerTableViewController.swift
//  SportsandPlayers
//
//  Created by Hajar Alomari on 27/12/2021.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController {
    
    let playerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var playersList: [Player] = []
    var sport: Sport? {
        didSet{
            fetchAllPlayers()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayerBtnPressed))
        //fetchAllPlayers()
       
    }
    
    @objc func addPlayerBtnPressed(){
        let alert = UIAlertController(title: "Add a Player", message: nil , preferredStyle: .alert)
    
        alert.addTextField { field in
            field.placeholder = "name"
        }
        alert.addTextField { field in
            field.placeholder = "age"
            field.keyboardType = .numberPad
        }
        alert.addTextField { field in
            field.placeholder = "height"
            field.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            guard let fields = alert?.textFields, fields.count == 3 else {
                return
            }
            let name = fields[0]
            let age = fields[1]
            let height = fields[2]
            
            guard let name = name.text , !name.isEmpty,
                  let age = age.text, !age.isEmpty,
                  let height = height.text , !height.isEmpty else{
                      return
                  }
            
            let ageInt = Int64(age) ?? 0
            let heightDouble = Double(height) ?? 0.0
        
            let newPlayer = Player(context: self.playerContext)
            newPlayer.name = name
            newPlayer.age = ageInt
            newPlayer.height = heightDouble
            newPlayer.parentSport = self.sport
            
            do {
                try self.playerContext.save()
                
                } catch {
                print("Error: \(error)")
                }
            self.fetchAllPlayers()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playersList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        let player = playersList[indexPath.row]
        cell.textLabel?.text = "\(player.name!) -- age: \(player.age) -- height: \(player.height)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Update a Player", message: nil , preferredStyle: .alert)
    
        alert.addTextField { field in
            field.placeholder = self.playersList[indexPath.row].name
        }
        alert.addTextField { field in
            field.placeholder = String(self.playersList[indexPath.row].age)
            field.keyboardType = .numberPad
        }
        alert.addTextField { field in
            field.placeholder = String(self.playersList[indexPath.row].height)
            field.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            guard let fields = alert?.textFields, fields.count == 3 else {
                return
            }
            let name = fields[0]
            let age = fields[1]
            let height = fields[2]
            
            guard let name = name.text , !name.isEmpty,
                  let age = age.text, !age.isEmpty,
                  let height = height.text , !height.isEmpty else{
                      return
                  }
            
            let ageInt = Int64(age) ?? 0
            let heightDouble = Double(height) ?? 0.0
        
            //let newPlayer = Player(context: self.playerContext)
            self.playersList[indexPath.row].name = name
            self.playersList[indexPath.row].age = ageInt
            self.playersList[indexPath.row].height = heightDouble
            self.playersList[indexPath.row].parentSport = self.sport
            
            do {
                try self.playerContext.save()
                
                } catch {
                print("Error: \(error)")
                }
            self.fetchAllPlayers()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchAllPlayers(with request: NSFetchRequest<Player> = Player.fetchRequest() ){
        let predicate = NSPredicate(format: "parentSport.name MATCHES %@", sport!.name!)
        request.predicate = predicate
        do{
            try playersList = playerContext.fetch(request)
            tableView.reloadData()
        }catch{
            print("Failed to fetch players")
        }
    }
    
//    func addPlayer (name: String, age: Int64 , height: Double){
//        let newPlayer = Player(context: playerContext)
//        newPlayer.name = name
//        newPlayer.age = age
//        newPlayer.height = height
//
//        do{
//            try playerContext.save()
//            fetchAllPlayers()
//        }catch{
//            print("Failed to save new player")
//        }
//    }

}
