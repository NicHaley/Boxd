//
//  ViewController.swift
//  Boxd
//
//  Created by Nicholas Haley on 2019-07-20.
//  Copyright © 2019 Nicholas Haley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func resizeImage(_ sender: Any) {
        if let unwrappedImage = self.imageView.image {
            self.imageView.image = drawImage(image: unwrappedImage)
        }
    }
    
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

