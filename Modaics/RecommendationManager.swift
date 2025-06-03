// RecommendationManager.swift

import Foundation
import CoreML
import UIKit
import Accelerate

/// Load the Core ML embedding model (ResNet50FeatureExtractor.mlmodel)
class RecommendationManager {
    static let shared = RecommendationManager()
    
    // 1) Core ML model for embedding
    private let resnetModel: ResNet50Embedding

    // 2) Precomputed embeddings (N × 2048) loaded from a bundled JSON/Plist
    private let embeddings: [[Float]]
    private let filenames: [String]

    // Initialize and load assets
    private init() {
        // Load Core ML model
        guard let model = try? ResNet50Embedding(configuration: .init()) else {
            fatalError("Failed to load Core ML model")
        }
        self.resnetModel = model
        
        // Load precomputed embeddings & filenames
        // Assume they are stored as two JSON arrays in the bundle:
        //   - Embeddings.json  ➔ [[Float]] 
        //   - Filenames.json   ➔ [String]
        guard let embedURL = Bundle.main.url(forResource: "Embeddings", withExtension: "json"),
              let fileURL = Bundle.main.url(forResource: "Filenames", withExtension: "json"),
              let embedData = try? Data(contentsOf: embedURL),
              let fileData = try? Data(contentsOf: fileURL),
              let loadedEmbeddings = try? JSONDecoder().decode([[Float]].self, from: embedData),
              let loadedFilenames = try? JSONDecoder().decode([String].self, from: fileData) else {
            fatalError("Failed to load embeddings or filenames JSON")
        }
        self.embeddings = loadedEmbeddings
        self.filenames = loadedFilenames
    }
    
    /// Given a UIImage, returns its 2048-dim embedding via Core ML
    func computeEmbedding(for uiImage: UIImage) -> [Float]? {
        // 1) Resize & crop to 224×224 (ResNet50 input size)
        guard let resized = uiImage.resizeTo(size: CGSize(width: 224, height: 224)),
              let buffer = resized.toCVPixelBuffer() else {
            return nil
        }

        // 2) Run Core ML model
        guard let output = try? resnetModel.prediction(input_image: buffer) else {
            return nil
        }
        // output.featureValue for key "output" is MLMultiArray1×2048
        guard let mlArray = output.featureValue(for: "output")?.multiArrayValue else {
            return nil
        }
        // Convert MLMultiArray (shape [1,2048]) to [Float]
        return mlArray.toArray()
    }
    
    /// Compute cosine similarity between two vectors
    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        // dot(a,b) / (||a|| * ||b||)
        var dot: Float = 0
        var normA: Float = 0
        var normB: Float = 0
        vDSP_dotpr(a, 1, b, 1, &dot, vDSP_Length(a.count))
        vDSP_svesq(a, 1, &normA, vDSP_Length(a.count))
        vDSP_svesq(b, 1, &normB, vDSP_Length(b.count))
        return dot / (sqrt(normA) * sqrt(normB) + 1e-8)
    }

    /// Given a query embedding, return the top K similar filenames
    func topKSimilarItems(query: [Float], k: Int = 5) -> [String] {
        // 1) Compute similarity with each stored embedding
        let similarities = embeddings.enumerated().map { (idx, storedVec) -> (Float, String) in
            let sim = cosineSimilarity(query, storedVec)
            return (sim, filenames[idx])
        }
        // 2) Sort descending by similarity and take top K (excluding the item itself if needed)
        let topK = similarities
            .sorted(by: { $0.0 > $1.0 })
            .prefix(k)
            .map(\.1)  // extract filename
        return Array(topK)
    }
}

/// MARK: UIImage extensions to handle resizing & CVPixelBuffer conversion
extension UIImage {
    /// Resize a UIImage to a target CGSize
    func resizeTo(size targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized
    }

    /// Convert UIImage to CVPixelBuffer (needed for Core ML image input)
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs as CFDictionary,
            &pixelBuffer
        )
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        let pxData = CVPixelBufferGetBaseAddress(buffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: pxData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        guard let cgCtx = context else {
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
            return nil
        }
        cgCtx.translateBy(x: 0, y: CGFloat(height))
        cgCtx.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(cgCtx)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
        return buffer
    }
}

/// MARK: MLMultiArray → [Float] helper
extension MLMultiArray {
    func toArray() -> [Float] {
        let count = self.count
        var array = [Float](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = self[i].floatValue
        }
        return array
    }
}
