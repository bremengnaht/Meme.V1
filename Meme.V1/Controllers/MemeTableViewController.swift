//
//  MemeTableViewController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 30/4/24.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: MUST HAVE FUNCTIONS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSharedDatasource().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCellTableIndentifier", for: indexPath) as! CustomTableViewCell
        
        let data = getSharedDatasource()[indexPath.row]
        cell.customImageView.image = data.memedImage
        cell.customDisplayName.text = "\(data.topText ?? "") \(data.bottomText ?? "")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewDetailTable", sender: getSharedDatasource()[indexPath.row].memedImage)
    }
    
    // MARK: Others
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        performSegue(withIdentifier: "MemeCreatorTable", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDetailTable" {
            let destination = segue.destination as! MemeViewDetailViewController
            destination.dataImage = (sender as! UIImage)
        }
    }
    
    private func getSharedDatasource() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
}
