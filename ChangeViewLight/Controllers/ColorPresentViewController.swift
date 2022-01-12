//
//  ColorPresentViewController.swift
//  ChangeViewLight
//
//  Created by Андрей Евдокимов on 11.01.2022.
//

import UIKit

protocol ColorSettingsViewControllerDelegate {
    func setNewColor(at color: UIColor)
}

class ColorPresentViewController: UIViewController {
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorSettingsVC = segue.destination as? ColorSettingsViewController else { return }

        colorSettingsVC.delegate = self
        colorSettingsVC.colorFromColorPresentVC = view.backgroundColor
    }
}

// MARK: - Delegate

extension ColorPresentViewController: ColorSettingsViewControllerDelegate {
    func setNewColor(at color: UIColor) {
        view.backgroundColor = color
    }
}
