//
//  ViewController.swift
//  SomeRandom
//
//  Created by Dhilip R on 19/12/25.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    
   lazy var tF: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter a text"
      //  tf.delegate = self
       tf.backgroundColor = .white
       tf.layer.borderWidth = 1
       tf.layer.masksToBounds = true
       tf.layer.cornerRadius = 10
       tf.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
       return tf
    }()
    
    @objc func textChanged(_ textField: UITextField) {
       // lbl.text = textField.text
    }

    
    lazy var lbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "User Input"
        return lbl
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 👈 THIS triggers didEndEditing
        return true
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tF.delegate = self
        
        setupViews()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func setupViews() {
        
        self.view.addSubview(tF)
        tF.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tF.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        tF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tF.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: tF.bottomAnchor, constant: 20).isActive = true
        lbl.centerXAnchor.constraint(equalTo: tF.centerXAnchor).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lbl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        lbl.text = textField.text
        
    }
    
    func textField(_ textField: UITextField, insertInputSuggestion inputSuggestion: UIInputSuggestion) {
        
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        lbl.text = textField.text
        return true
    }

    
}

