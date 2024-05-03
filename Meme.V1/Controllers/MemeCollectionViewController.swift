//
//  MemeCollectionViewController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 30/4/24.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
   
    // MARK: MUST HAVE FUNCTIONS
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getSharedDatasource().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCellCollectionIndentifier", for: indexPath) as! CustomCollectionViewCell
        
        let data = getSharedDatasource()[indexPath.row]
        cell.customImageView.image = data.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewDetailCollection", sender: getSharedDatasource()[indexPath.row].memedImage)
    }
    
    // MARK: Others
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        performSegue(withIdentifier: "MemeCreatorCollection", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDetailCollection" {
            let destination = segue.destination as! MemeViewDetailViewController
            destination.dataImage = (sender as! UIImage)
        }
    }
    
    private func getSharedDatasource() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
}
