//
//  ColorSettingsViewController.swift
//  ChangeViewLight
//
//  Created by Андрей Евдокимов on 17.12.2021.
//

import UIKit

class ColorSettingsViewController: UIViewController {

    @IBOutlet var viewColor: UIView!

    @IBOutlet var redSliderValueLabel: UILabel!
    @IBOutlet var greenSliderValueLabel: UILabel!
    @IBOutlet var blueSliderValueLabel: UILabel!
    
    @IBOutlet var colorChangedSliders: [UISlider]!
    
    var delegate: ColorSettingsViewControllerDelegate!
    var colorFromColorPresentVC: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewColor.layer.cornerRadius = 16
        viewColor.backgroundColor = colorFromColorPresentVC
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        setColorForColorView()
        setTextForValueLabel(from: sender)
    }

    @IBAction func returnToMainScreen() {
        dismiss(animated: true)
    }
    
    private func setColorForColorView() {
        var colors: [String: CGFloat] = [:]

        for slider in colorChangedSliders {
            guard let key = slider.restorationIdentifier else { return }
            
            colors.updateValue(CGFloat(slider.value), forKey: key)
        }
        
        viewColor.backgroundColor = UIColor(
            red: colors["red"] ?? 0,
            green: colors["green"] ?? 0,
            blue: colors["blue"] ?? 0,
            alpha: 1
        )
    }
    
    private func setTextForValueLabel(from sender: UISlider) {
        if let restorationIdentifier = sender.restorationIdentifier {
            let colorOfView = ColorsOfView(rawValue: restorationIdentifier)

            switch colorOfView {
            case .red:
                redSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .green:
                greenSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .blue:
                blueSliderValueLabel.text = String(format: "%.2f", sender.value)
            case .none:
                print("error")
            }
        }
    }
}

extension ColorSettingsViewController {
    enum ColorsOfView: String {
        case red = "red"
        case green = "green"
        case blue = "blue"
    }
}
