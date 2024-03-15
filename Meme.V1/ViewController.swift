//
//  ViewController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 15/3/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imagePickerView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        UIActivityViewController
    }
    
    @IBAction func captureAnImage(_ sender: Any) {
        let takeImageController = UIImagePickerController()
        takeImageController.sourceType = .camera
        takeImageController.delegate = self
        present(takeImageController, animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        present(pickImageController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        self.imagePickerView.image = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

