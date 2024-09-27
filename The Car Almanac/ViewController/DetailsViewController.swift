//
//  DetailsViewController.swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var detailInfoLabel: UILabel!
    @IBOutlet var imageCar: UIImageView?
    
    var car: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyRedBlackGradient()
        navigationItem.title = car?.name?.capitalized ?? "Unknown Car"
        textInfo()
        textLine()
        imageFix()
    }
}

//MARK: - UpdateUI
extension DetailsViewController {
    private func textLine() {
        if let labelText = detailInfoLabel.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            detailInfoLabel.attributedText = attributedString
        }
    }
    
    private func textInfo() {
        if let car = car {
            let detailsText = """
                    Name: \(car.name?.capitalized ?? "Unknown")
                    Miles Per Gallon: \(car.milesPerGallon ?? Int.random(in: 10...15))
                    Cylinders: \(car.cylinders ?? 0)
                    Displacement: \(car.displacement ?? 0)
                    Horsepower: \(car.horsepower ?? 0)
                    Weight: \(car.weightInLbs ?? Int.random(in: 2500...3500)) lbs
                    Acceleration: \(car.acceleration ?? 0) sec
                    Year: \(car.year ?? "Unknown")
                    Country of manufacture: \(car.origin ?? "Unknown")
                    """
            
            detailInfoLabel.text = detailsText
            
            if let carName = car.name {
                imageCar?.image = UIImage(named: carName)
            } else {
                imageCar?.image = UIImage(named: "defaultImage")
            }
        }
    }
    private func imageFix() {
        imageCar?.contentMode = .scaleAspectFill
        imageCar?.layer.cornerRadius = 15
        imageCar?.clipsToBounds = true
    }
}
extension UIView {
    func applyRedBlackGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
    




