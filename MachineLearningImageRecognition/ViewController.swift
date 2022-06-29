//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by Erge Gevher Akova on 29.06.2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func changeClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        recognizeImage(image: imageView.image!)
    }
    
    func recognizeImage(image: UIImage){
        if let ciImage = CIImage(image: image){chosenImage = ciImage}
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { vnRequest, error in
                if let results = vnRequest.results as? [VNClassificationObservation]{
                    if results.count > 0 {
                        let topResult = results.first
                        
                        DispatchQueue.main.async {
                            let confidenceLevel = (topResult?.confidence ?? 0)  * 100
                            self.lblResult.text = "\(confidenceLevel) - \(topResult?.identifier)"
                        }
                    }
                }
            }
        }
    }

}

