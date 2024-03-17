//
//  MemeCreatorController.swift
//  Meme.V1
//
//  Created by Nguyen Quyet Thang on 15/3/24.
//

import UIKit

class MemeCreatorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: Property
    @IBOutlet var imageViewFrame: UIImageView!
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var bottomToolbar: UIToolbar!
    
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    let defaultTopTextField: String = "TOP"
    let defaultBottomTextField: String = "BOTTOM"
    
    let imagePickerController = UIImagePickerController()
    var shouldUpdateFrame: Bool = false
    
    // MARK: OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        
        // Doesn't work on Apple Silicon Macs. This return TRUE even on simulator.
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self.hideKeyboardWhenTapOnScreen()
        self.configTextField(textField: self.topTextField, defaultText: self.defaultTopTextField)
        self.configTextField(textField: self.bottomTextField, defaultText: self.defaultBottomTextField)
        self.verifyShareButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardOservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardOservers()
    }
    
    // MARK: DELEGATE
    /// Select or capture image successfully
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        self.imageViewFrame.image = info[.originalImage] as? UIImage
        self.verifyShareButtonState()
    }
    
    /// Cancel select or capture image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
        self.verifyShareButtonState()
    }
    
    /// Prevent push up screen when edit top textField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.shouldUpdateFrame = textField === self.bottomTextField
        return true
    }
    
    /// Remove default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === self.topTextField {
            if self.topTextField.text == self.defaultTopTextField {
                self.topTextField.text = nil
                return
            }
        }
        if textField === self.bottomTextField {
            if self.bottomTextField.text == self.defaultBottomTextField {
                self.bottomTextField.text = nil
                return
            }
        }
    }
    
    // Hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    // MARK: STORYBOARD'S ACTION
    /// Click capture button on toolbar
    @IBAction func captureAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true)
    }
    
    /// Click library button on toolbar
    @IBAction func pickAnImage(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true)
    }
    
    /// Click share botton on top toolbar
    @IBAction func shareMeme(_ sender: Any) {
        if let originalImage = self.imageViewFrame.image {
            // Generate memed image
            let bounds = self.view.bounds
            let renderer = UIGraphicsImageRenderer(size: bounds.size)
            let memedImage: UIImage = renderer.image(actions: { _ in
                self.changeToolbarsVisibility(isHidden: true)
                self.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                self.changeToolbarsVisibility(isHidden: false)
            })
            // TODO
            let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: originalImage, memedImage: memedImage)
            
        }
    }
    
    /// Reset meme
    @IBAction func cancelButton(_ sender: Any) {
        self.imageViewFrame.image = nil
        self.topTextField.text = self.defaultTopTextField
        self.bottomTextField.text = self.defaultBottomTextField
        self.verifyShareButtonState()
    }
    
    // MARK: LAYOUT DESIGN
    /// Update text field style to match with requirement
    func configTextField(textField: UITextField, defaultText: String) {
        textField.delegate = self
        let memeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -5,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.text = defaultText
        textField.minimumFontSize = 12
    }
    
    func changeToolbarsVisibility(isHidden: Bool) {
        self.topToolbar.isHidden = isHidden
        self.bottomToolbar.isHidden = isHidden
    }
    
    func verifyShareButtonState() {
        self.shareButton.isEnabled = self.imageViewFrame.image !== nil
    }
    
    // MARK: KEYBOARD'S PROCESS
    /// Add Observer for show and hide keyboard
    func addKeyboardOservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Remove Observer for show and hide keyboard
    func removeKeyboardOservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Change frame position to make keyboard textField visible
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.shouldUpdateFrame {
            view.frame.origin.y -= self.getKeyboardHeight(notification);
        }
    }
    
    /// Set to frame back to normal
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0;
    }
    
    /// Keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let buffer = CGFloat(10);
        return (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height + buffer
    }
    
    /// Dismiss Keyboard when tap anywhere on the screen
    func hideKeyboardWhenTapOnScreen() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    /// Dismiss Keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

struct Meme {
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage
    var memedImage: UIImage
}
