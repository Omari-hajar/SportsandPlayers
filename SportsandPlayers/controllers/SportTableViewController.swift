//
//  SportTableViewController.swift
//  SportsandPlayers
//
//  Created by Hajar Alomari on 27/12/2021.
//

import UIKit
import CoreData

class SportTableViewController: UITableViewController, ImagePickerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
  
    
    
    let sportContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sports: [Sport] = []
    var index: IndexPath?
    
    var selectedIndexInt: Int = 0
    var tempImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonPressed))
        fetchAllSports()
        
    }

    @objc func addBarButtonPressed() {
    
        let alert = UIAlertController(title: "Add a Sport", message: nil , preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "type sport"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let name = textField?.text{
                self.addSport(name: name)
            }
           
        }))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SportTableViewCell
        cell.sportNameLabel.text = sports[indexPath.row].name
        cell.imagePickerDelegate = self
        cell.imageBtn.tag = indexPath.row
        cell.imageBtn.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func whichButtonPressed(sender: UIButton) {
    selectedIndexInt = sender.tag

    }
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let cell:SportTableViewCell = tableView.cellForRow(at: IndexPath(row: selectedIndexInt, section: 0)) as! SportTableViewCell
            cell.sportImageIV.image = image
            
        }

        picker.dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sport = sports[indexPath.row]
        performSegue(withIdentifier: "goToPlayer", sender: sport)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlayer" {
        let playerVC = segue.destination as? PlayerTableViewController
            if let index = tableView.indexPathForSelectedRow {
                playerVC?.sport = sports[index.row]
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            sportContext.delete(sports[indexPath.row])
            fetchAllSports()
            
            }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Update a Sport", message: nil , preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.sports[indexPath.row].name
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let name = textField?.text{
                self.sports[indexPath.row].name = name
                
            }
            do{
                try self.sportContext.save()
                tableView.reloadData()
            }catch{
                print("Failed to update")
            }
           
        }))

        self.present(alert, animated: true, completion: nil)
        
    }
    func fetchAllSports() {
        do{
            sports = try sportContext.fetch(Sport.fetchRequest())
            tableView.reloadData()
        }catch{
            
            print("Failed to fetch sports")
        }
    }
    
    
    func addSport(name: String){
        let newSport = Sport(context: sportContext)
        newSport.name = name
        do{
            try sportContext.save()
            fetchAllSports()
        }catch{
            print("Failed to add a sport")
        }
    }

}
