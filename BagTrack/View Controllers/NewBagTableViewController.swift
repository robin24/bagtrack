//
//  NewBagTableViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 14.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit
import CoreLocation

protocol NewBagDelegate:class {
    func newBagController(_ controller: NewBagTableViewController, didFinishAdding bag:Bag)
}
class NewBagTableViewController: UITableViewController {

    // MARK: - Properties

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var minorField: UITextField!
    @IBOutlet weak var identifierField: UITextField!
    var textFields:[UITextField] = []
    weak var delegate:NewBagDelegate?

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [nameField, uuidField, majorField, minorField, identifierField]
        nameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        if !nameField.text!.isEmpty && !uuidField.text!.isEmpty && !majorField.text!.isEmpty && !minorField.text!.isEmpty && !identifierField.text!.isEmpty {
            guard let proximityUUID = UUID(uuidString: uuidField.text!) else {
                showAlert()
                return
            }
            guard let majorInt = Int(majorField.text!) else {
                showAlert()
                return
            }
            let majorValue = CLBeaconMajorValue(majorInt)
            guard let minorInt = Int(minorField.text!) else {
                showAlert()
                return
            }
            let minorValue = CLBeaconMinorValue(minorInt)
            let bag = Bag(name: nameField.text!, proximityUUID: proximityUUID, majorValue: majorValue, minorValue: minorValue, beaconID: identifierField.text!)
            delegate?.newBagController(self, didFinishAdding: bag)
            dismiss(animated: true, completion: nil)

        }
    }
    func showAlert() {
        let controller = UIAlertController(title: "Invalid Data",
                                           message: "The information you provided is invalid.",
                                           preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITextFieldDelegate

extension NewBagTableViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for (index, field) in textFields.enumerated() {
            if field == textField {
                field.resignFirstResponder()
                if index + 1 < textFields.count {
                    let nextField = textFields[index + 1]
                    nextField.becomeFirstResponder()
                    return true
                }
            }
        }
        onSaveButtonTapped(textField)
        return true
    }
}
