//
//  ViewController.swift
//  MLSeaFood
//
//  Created by Abdelrahman-Arw on 12/24/19.
//  Copyright © 2019 Abdelrahman-Arw. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - IBActions and outles
    @IBAction func barBtnCamera(_ sender: UIBarButtonItem) {
        present(imagePicker,animated: true,completion: nil)
    }
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK: - Variables
    let imagePicker = UIImagePickerController()
    
    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    //MARK: - image picking delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
           imgView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else { fatalError("couldn't convert to ci image")}
            detect(image: ciImage )
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Loading coreml model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("couldn't cast into vn classification observation")}
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog!"
                } else {
                    self.navigationItem.title = "Not HotDog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try! handler.perform([request])
        } catch {
            print(error)
        }
       
    }

}

