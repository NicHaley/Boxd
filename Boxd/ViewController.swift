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
        let canvasSize = CGSize(width: 400, height: 400)
        let rect = CGRect(x: 0, y: 0, width: 400, height: 400)
        let color = UIColor(white: 0.5, alpha: 1)
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        image.draw(in: CGRect(x: 50, y: 0, width: 300, height: canvasSize.height))
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

