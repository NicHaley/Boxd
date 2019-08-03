//
//  ViewController.swift
//  Boxd
//
//  Created by Nicholas Haley on 2019-07-20.
//  Copyright © 2019 Nicholas Haley. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func showImagePicker(_ sender: UIBarButtonItem) {
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func resizeImage(_ sender: Any) {
        if let unwrappedImage = self.imageView.image {
            self.imageView.image = drawImage(image: unwrappedImage)
        }
    }
    
    @IBAction func Save(_ sender: Any) {
        if let unwrappedImage = self.imageView.image {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: unwrappedImage)
            }, completionHandler: { success, error in
                if success {
                    // Saved successfully!
                    UIImageWriteToSavedPhotosAlbum(unwrappedImage, nil, nil, nil);
                }
                else if let error = error {
                    // Save photo failed with error
                }
                else {
                    // Save photo failed with no error
                }
            })
        }
    }
    
    // Need to output image without resoltion loss. Look at:
    // https://stackoverflow.com/questions/52070189/keep-same-image-quality-after-converting-in-swift
    // https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer
    func drawImage(image: UIImage) -> UIImage {
        let screenWidth = self.view.frame.size.width;
        let canvasSize = CGSize(width: screenWidth, height: screenWidth)
        let rect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        let color = UIColor(white: 0.5, alpha: 1)
        
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        
        let imageHeightWidthRatio = imageHeight / imageWidth
        var imageRect: CGRect
        
        if imageHeightWidthRatio > 1 {
            let newWidth = canvasSize.width / imageHeightWidthRatio
            imageRect = CGRect(x: (canvasSize.width - newWidth) / 2, y: 0, width: newWidth, height: canvasSize.height)
        } else if imageHeightWidthRatio < 1 {
            let newHeight = canvasSize.height * imageHeightWidthRatio
            imageRect = CGRect(x: 0, y: (canvasSize.height - newHeight) / 2, width: canvasSize.width, height: newHeight)
        } else {
            imageRect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        }
        
        print(imageHeight, imageWidth, imageRect)
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        image.draw(in: imageRect)
        let renderImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderImage!
    }
}

extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}

