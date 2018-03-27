//
//  MLDataInitilializer.swift
//  ImageAway
//
//  Created by Rajesh Kumar Yadav on 3/26/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision

class MLDataHelper{
    var listing_data:[[MLImage]] = []
    let listing_images_size = [28,14]
    var allowedFilterList = [[String]]()
    
    init() {
        if let list = MLDataHelper.loadPList("FilterTag") as? [[String]]{
            allowedFilterList = list
        }
    }
    
    func filters(listing_data:[MLImage]) -> [[String]] {
        var filters = [[String]]()
        for allowed_filter in allowedFilterList{
            for innerFilter in allowed_filter{
                var found = false
                for data in listing_data{
                    if let has = data.tag?.lowercased().contains(innerFilter.lowercased()), has == true{
                        filters.append(allowed_filter)
                        found = true
                        break
                    }
                }
                if found {break}
            }
        }
       
        return filters
    }
    
    func sort(listing_data:[MLImage],with filters:[String]) -> [MLImage] {
        var filters_data = [MLImage]()
        for data in listing_data{
            for filter in filters{
                if let has = data.tag?.lowercased().contains(filter.lowercased()), has == true{
                    filters_data.append(data)
                    break
                }
            }
        }
        
        filters_data.sort { (first, second) -> Bool in
            first.probability > second.probability
        }
        
        return filters_data
    }
}

extension MLDataHelper{
    static func loadPList(_ name:String) ->NSArray?{
        let bundle = Bundle(for: MLDataHelper.self)
        if let path = bundle.path(forResource: name, ofType: "plist"){
            return NSArray(contentsOfFile: path)
        }
        return nil
    }
    
    
    static func initialize() -> MLDataHelper{
        let mlData = MLDataHelper()
        // MARK: Listing 1 data
        for listing_index in 1...mlData.listing_images_size.count{
            var listing_metaData = [MLImage]()
            for index in 1...mlData.listing_images_size[0]{
                if let image = UIImage(named:"image_l\(listing_index)_\(index)"){
                    let mlImage = MLImage(image: image)
                    listing_metaData.append(mlImage)
                    //                    predictImage(mlImage: mlImage,imageName:"image_l\(listing_index)_\(index)")
                    recognizeImage(mlImage: mlImage, imageName: "image_l\(listing_index)_\(index)")
                }
            }
            mlData.listing_data.append(listing_metaData)
        }
        return mlData
    }
    
    static func predictImage(mlImage:MLImage, imageName:String){
        if let inputBuffer = MLDataHelper.buffer(from: mlImage.image){
            let input = GoogLeNetPlacesInput(sceneImage:inputBuffer)
            do{
                let output = try GoogLeNetPlaces().prediction(input: input)
                //                mlImage.probability = output.sceneLabelProbs
                mlImage.tag = output.sceneLabel
                mlImage.set(tag: output.sceneLabel)
            }
            catch{ print("error in model predition \(imageName)")}
        }
    }
    
    static func recognizeImage(mlImage:MLImage, imageName:String) {
        guard let image = CIImage(image: mlImage.image) else {
            return
        }
        
        if let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) {
            let request = VNCoreMLRequest(model: model, completionHandler: { (vnrequest, error) in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    let topResult = results.first
                    DispatchQueue.main.async {
                        let confidenceRate = (topResult?.confidence)! * 100
                        let rounded = Double (confidenceRate * 100) / 100
                        mlImage.set(tag: topResult?.identifier, probability: rounded)
                    }
                }
            })
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("error in model predition \(imageName)")
                }
            }
        }
    }
    
    static func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
