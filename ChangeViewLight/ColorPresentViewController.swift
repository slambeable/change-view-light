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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(200)
        guard let colorSettingsVC = segue.destination as? ColorSettingsViewController else { return }

        colorSettingsVC.delegate = self
        colorSettingsVC.colorFromColorPresentVC = view.backgroundColor
    }
}

extension ColorPresentViewController: ColorSettingsViewControllerDelegate {
    func setNewColor(at color: UIColor) {
    }
}
