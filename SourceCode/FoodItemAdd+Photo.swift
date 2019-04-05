//
//  FoodItemAdd+Photo.swift
//  Assign4
//
//  Created by josh on 2018-11-25.
//  Copyright © 2018 SICT. All rights reserved.
//

import UIKit


extension FoodItemAdd: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Lifecycle
    
    func choosePhotoFrom(_ type: UIImagePickerController.SourceType ) {
        let c = UIImagePickerController()
        c.sourceType = type
        c.delegate = self
        c.allowsEditing = false
        present(c, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        choosePhotoFrom(.photoLibrary)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFrom(.photoLibrary)
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                      handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo",
                                     style: .default, handler: { _ in
                                        self.choosePhotoFrom(.camera)
        })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library",
                                       style: .default, handler: { _ in
                                        self.choosePhotoFrom(.photoLibrary)
        })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image picker delegate methods
    
    // Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // Save
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photo = image
        
        imagePicker.setImage(photo, for: .normal)
        imagePicker.setImage(photo, for: .selected)
        imagePicker.setImage(photo, for: .focused)
        
        if infoBox.text! == "Missing photo" {
            self.clearErrorMessage()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
