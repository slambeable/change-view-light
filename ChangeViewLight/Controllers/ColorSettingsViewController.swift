//
//  ColorSettingsViewController.swift
//  ChangeViewLight
//
//  Created by Андрей Евдокимов on 17.12.2021.
//

import UIKit

class ColorSettingsViewController: UIViewController {

    @IBOutlet var viewColor: UIView!
    
    @IBOutlet var sliderValueLabels: [UILabel]!
    @IBOutlet var colorChangedSliders: [UISlider]!
    @IBOutlet var colorChangedTextField: [UITextField]!

    var delegate: ColorSettingsViewControllerDelegate!
    var colorFromColorPresentVC: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewColor.layer.cornerRadius = 16
        viewColor.backgroundColor = colorFromColorPresentVC
        
        setStartValueForLabels()
        setStartValueForSliders()
        setStartValueForTextFields()
        
        addDoneButtonOnKeyboard()
        setDelegateForTextFields()
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        setColorForColorView()
        setTextForValueLabelAndTextField(from: sender)
    }

    @IBAction func returnToMainScreen() {
        delegate.setNewColor(at: viewColor.backgroundColor ?? UIColor.white)
        dismiss(animated: true)
    }
}

// MARK: - ColorsOfViewEnum

extension ColorSettingsViewController {
    enum ColorsOfView: Int {
        case red
        case green
        case blue
    }
}

// MARK: - SetStartValue

extension ColorSettingsViewController {
    private func setStartValueForLabels() {
        for (index, label) in sliderValueLabels.enumerated() {
            guard let colorOfView = ColorsOfView(rawValue: index) else { return }
    
            switch colorOfView {
            case .red:
                label.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).red)
            case .green:
                label.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).green)
            case .blue:
                label.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).blue)
            }
        }
    }
    
    private func setStartValueForSliders() {
        for (index, slider) in colorChangedSliders.enumerated() {
            guard let colorOfView = ColorsOfView(rawValue: index) else { return }
    
            switch colorOfView {
            case .red:
                slider.value = Float(CIColor(color: colorFromColorPresentVC).red)
            case .green:
                slider.value = Float(CIColor(color: colorFromColorPresentVC).green)
            case .blue:
                slider.value = Float(CIColor(color: colorFromColorPresentVC).blue)
            }
        }
    }
    
    private func setStartValueForTextFields() {
        for (index, textField) in colorChangedTextField.enumerated() {
            guard let colorOfView = ColorsOfView(rawValue: index) else { return }
            
            switch colorOfView {
            case .red:
                textField.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).red)
            case .green:
                textField.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).green)
            case .blue:
                textField.text = String(format: "%.2f", CIColor(color: colorFromColorPresentVC).blue)
            }
        }
    }
}

// MARK: - SetSettingsForKeypad

extension ColorSettingsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 50)
        )

        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        for textField in colorChangedTextField {
            textField.inputAccessoryView = doneToolbar
        }
    }
    
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
    
    private func setDelegateForTextFields() {
        for textField in colorChangedTextField {
            textField.delegate = self
        }
    }
}

// MARK: - SliderHandlers

extension ColorSettingsViewController {
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
    
    private func setTextForValueLabelAndTextField(from sender: UISlider) {
        for (index, slider) in colorChangedSliders.enumerated() {
            if slider == sender {
                guard let colorOfView = ColorsOfView(rawValue: index) else { return }

                sliderValueLabels[colorOfView.rawValue].text = String(format: "%.2f", sender.value)
                colorChangedTextField[colorOfView.rawValue].text = String(format: "%.2f", sender.value)
            }
        }
    }
}

// MARK: - EndEditingHandler

extension ColorSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let number = Float(textField.text!) else { return }
        
        if number < 0 || number > 1 {
            showAlert(
                title: "Некорректные данные",
                message: "Вы можете выбрать только числа от 0 до 1 включительно."
            )
        } else {
            let truncatedText = String(format: "%.2f", number)

            for (index, currentTextField) in colorChangedTextField.enumerated() {
                if currentTextField == textField {
                    guard let colorOfView = ColorsOfView(rawValue: index) else { return }

                    sliderValueLabels[colorOfView.rawValue].text = truncatedText
                    colorChangedSliders[colorOfView.rawValue].value = Float(truncatedText) ?? 0.00
                    
                    setColorForColorView()
                }
            }
            
            textField.text = String(format: "%.2f", number)
        }
    }
}

// MARK: - AlertSettings

extension ColorSettingsViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
