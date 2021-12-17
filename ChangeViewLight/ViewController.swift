//
//  ViewController.swift
//  ChangeViewLight
//
//  Created by Андрей Евдокимов on 17.12.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var viewColor: UIView!

    @IBOutlet var redSliderValueLabel: UILabel!
    @IBOutlet var greenSliderValueLabel: UILabel!
    @IBOutlet var blueSliderValueLabel: UILabel!
    
    private var red = CGFloat(1)
    private var green = CGFloat(1)
    private var blue = CGFloat(1)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewColor.layer.cornerRadius = 16
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        if let restorationIdentifier = sender.restorationIdentifier {
            let colorOfView = ColorsOfView(rawValue: restorationIdentifier)
            
            switch colorOfView {
            case .red:
                red = CGFloat(sender.value)
                redSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .green:
                green = CGFloat(sender.value)
                greenSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .blue:
                blue = CGFloat(sender.value)
                blueSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .none:
                print("error")
            }
        }

        viewColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension ViewController {
    private enum ColorsOfView: String {
    case red
    case green
    case blue
    }
}
