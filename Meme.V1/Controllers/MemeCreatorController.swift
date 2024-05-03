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
        imagePickerController.delegate = self
        
        #if targetEnvironment(simulator)
            cameraButton.isEnabled = false
        #else
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
        
        hideKeyboardWhenTapOnScreen()
        configTextField(textField: topTextField, defaultText: defaultTopTextField)
        configTextField(textField: bottomTextField, defaultText: defaultBottomTextField)
        verifyShareButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardOservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardOservers()
    }
    
    // MARK: DELEGATE
    /// Select or capture image successfully
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        imageViewFrame.image = info[.originalImage] as? UIImage
        verifyShareButtonState()
    }
    
    /// Cancel select or capture image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        verifyShareButtonState()
    }
    
    /// Prevent push up screen when edit top textField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        shouldUpdateFrame = textField === bottomTextField
        return true
    }
    
    /// Remove default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === topTextField {
            if topTextField.text == defaultTopTextField {
                topTextField.text = nil
                return
            }
        }
        if textField === bottomTextField {
            if bottomTextField.text == defaultBottomTextField {
                bottomTextField.text = nil
                return
            }
        }
    }
    
    // Hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    // MARK: STORYBOARD'S ACTION
    /// Click capture button on toolbar
    @IBAction func captureAnImage(_ sender: Any) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    /// Click library button on toolbar
    @IBAction func pickAnImage(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    /// Click share botton on top toolbar
    @IBAction func shareMeme(_ sender: Any) {
        if let originalImage = imageViewFrame.image {
            // Generate memed image
            let bounds = view.bounds
            let renderer = UIGraphicsImageRenderer(size: bounds.size)
            let memedImage: UIImage = renderer.image(actions: { _ in
                changeToolbarsVisibility(isHidden: true)
                view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                changeToolbarsVisibility(isHidden: false)
            })
            
            // Open activity view
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                if completed {
                    self.saveMeme(originalImage: originalImage, memedImage: memedImage)
                    self.dismiss(animated: true)
                }
            }
            present(activityViewController, animated: true)
        }
    }
    
    /// Reset meme
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
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
        topToolbar.isHidden = isHidden
        bottomToolbar.isHidden = isHidden
    }
    
    func verifyShareButtonState() {
        shareButton.isEnabled = imageViewFrame.image !== nil
    }
    
    // MARK: KEYBOARD'S PROCESS
    /// Add Observer for show and hide keyboard
    func addKeyboardOservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Remove Observer for show and hide keyboard
    func removeKeyboardOservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Change frame position to make keyboard textField visible
    @objc func keyboardWillShow(_ notification: Notification) {
        if shouldUpdateFrame {
            view.frame.origin.y -= getKeyboardHeight(notification);
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: SAVE MEME
    /// Has been called after save meme on Activity View
    func saveMeme(originalImage: UIImage, memedImage: UIImage) {
        let newMeme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: originalImage, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(newMeme)
    }
}
