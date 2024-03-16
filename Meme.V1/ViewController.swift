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
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        
        // Doesn't work on Apple Silicon Macs. This return TRUE even on simulator.
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self._configTextFieldStyle(textField: self.topTextField, defaultText: "TOP")
        self._configTextFieldStyle(textField: self.bottomTextField, defaultText: "BOTTOM")
    }
    
    @IBAction func captureAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        self.imagePickerView.image = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    private func _configTextFieldStyle(textField: UITextField, defaultText: String) {
        let memeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
            NSAttributedString.Key.strokeWidth:  3,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.text = defaultText
        textField.minimumFontSize = 12
    }
    
}

