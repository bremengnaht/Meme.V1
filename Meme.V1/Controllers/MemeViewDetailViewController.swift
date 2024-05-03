//
//  MemeViewDetailViewController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 30/4/24.
//

import UIKit

class MemeViewDetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var dataImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = dataImage {
            imageView.image = data
        }
        
    }
}
