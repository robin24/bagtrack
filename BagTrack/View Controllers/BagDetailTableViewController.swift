//
//  BagDetailTableViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 14.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit
import CoreLocation

protocol BagDetailDelegate:class {
    func bagDetailController(_ controller: BagDetailTableViewController, didFinishAdding bag:Bag)
    func bagDetailController(_ controller:BagDetailTableViewController, didFinishEditing bag:Bag, at indexPath:IndexPath)
}
class BagDetailTableViewController: UITableViewController {

    // MARK: - Properties

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var minorField: UITextField!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var bag:Bag!
    var indexPath:IndexPath?
    var textFields:[UITextField] = []
    weak var delegate:BagDetailDelegate?

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bag = bag {
            nameField.text = bag.name
            uuidField.text = bag.proximityUUID.uuidString
            majorField.text = String(bag.majorValue)
            minorField.text = String(bag.minorValue)
            identifierField.text = bag.beaconID
        }
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
                present(Helpers.showAlert(.invalidData, error: nil), animated: true, completion: nil)
                return
            }
            guard let majorInt = Int(majorField.text!) else {
                present(Helpers.showAlert(.invalidData, error: nil), animated: true, completion: nil)
                return
            }
            let majorValue = CLBeaconMajorValue(majorInt)
            guard let minorInt = Int(minorField.text!) else {
                present(Helpers.showAlert(.invalidData, error: nil), animated: true, completion: nil)
                return
            }
            let minorValue = CLBeaconMinorValue(minorInt)
            bag = Bag(name: nameField.text!, proximityUUID: proximityUUID, majorValue: majorValue, minorValue: minorValue, beaconID: identifierField.text!)
            if let indexPath = indexPath {
                delegate?.bagDetailController(self, didFinishEditing: bag, at: indexPath)
                dismiss(animated: true, completion: nil)
                return
            }
            delegate?.bagDetailController(self, didFinishAdding: bag)
            dismiss(animated: true, completion: nil)
        }
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

extension BagDetailTableViewController:UITextFieldDelegate {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !nameField.text!.isEmpty && !uuidField.text!.isEmpty && !majorField.text!.isEmpty && !minorField.text!.isEmpty && !identifierField.text!.isEmpty {
            saveButton.isEnabled = true
        }
        return true
    }
}
