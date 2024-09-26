//
//  DetailsViewController.swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
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
        imageCar?.contentMode = .scaleAspectFill // Заполняем UIImageView без искажения пропорций
        imageCar?.layer.cornerRadius = 15 // Скругленные углы
        imageCar?.clipsToBounds = true // Обрезаем содержимое по границам
    }
}
extension UIView {
    func applyRedBlackGradient() {
        let gradientLayer = CAGradientLayer()
        
        // Цвета градиента — красный и чёрный
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        
        // Определяем расположение цветов: красный сверху, чёрный снизу
        gradientLayer.locations = [0.0, 1.0]
        
        // Направление градиента — сверху вниз (по вертикали)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Вверху посередине
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Внизу посередине
        
        // Устанавливаем границы градиента, чтобы они соответствовали размеру представления
        gradientLayer.frame = self.bounds
        
        // Добавляем градиент на слой представления
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
    




