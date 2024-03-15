//
//  ViewController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 15/3/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        
        // Doesn't work on Apple Silicon Macs. This return TRUE even on simulator.
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func captureAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        present(self.imagePickerController, animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        self.imagePickerView.image = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

