//
//  authorization.swift
//  test-app
//
//  Created by Alexander Rogov on 05/08/2019.
//  Copyright © 2019 Alexander Rogov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var validationLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func btnSignInClick(_ sender: UIButton) {
        var emailIsValid: Bool = true
        var passwordIsValid: Bool = true
        
        validationLabel.text = ""
        
        if !(emailField.text?.isValidEmail)!{
            validationLabel.text = "- Неверный формат электронной почты."
            emailIsValid = false
        }
        
        if !(passwordField.text?.isValidPassword)!{
            validationLabel.text = validationLabel.text! + "\n- Пароль должен содержать не менее 6 символов. Пароль должен включать буквы верхнего и нижнего регистра и хотя бы одну цифру."
            passwordIsValid = false
        }
        
        if (emailIsValid && passwordIsValid) {
            print("Success")
            let headers: HTTPHeaders = [
                "X-Yandex-API-Key": "13d3ab6e-80d5-49dd-bc3e-dbcff253b5b4",
                "Accept": "application/json"
            ]
        AF.request("https://api.weather.yandex.ru/v1/forecast?lat=54.186333&lon=45.183984&limit=1&hours=false&extra=false", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.data {
                        do{
                            let data = try JSON(data: json)
                            
                            let message = "Температура (°C): \(data["fact"]["temp"])\nСкорость ветра (в м/с): \(data["fact"]["wind_speed"])\nДавление (в мм рт. ст.): \(data["fact"]["pressure_mm"])"
                            let alert = UIAlertController(title: "Погода в Саранске", message: message, preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                            self.present(alert, animated: true, completion: nil)
                        }
                        catch{
                            print("JSON Error")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        passwordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 0).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        passwordLabel.isHidden = true
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -20).isActive = true
        emailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailField.keyboardType = .emailAddress
        
        emailLabel.isHidden = true
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: emailField.topAnchor, constant: 0).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 35).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signInButton.layer.cornerRadius = 25.0
        signInButton.titleEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 50)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        validationLabel.translatesAutoresizingMaskIntoConstraints = false
        validationLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
        validationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        validationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size.height == UIScreen.main.bounds.height {
                self.view.frame.size.height -= keyboardSize.height
            } else {
                self.view.frame.size.height = UIScreen.main.bounds.height - keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.size.height != UIScreen.main.bounds.height {
            self.view.frame.size.height = UIScreen.main.bounds.height
        }
    }
    
    override func viewDidLayoutSubviews() {
        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        
        emailField.contentVerticalAlignment = .bottom
        passwordField.contentVerticalAlignment = .bottom
        
        let button = UIButton(type: .custom)
        button.setTitle("Забыли пароль?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(UIColor(named: "#brownish_grey"), for: .normal)
        button.frame = CGRect(x: CGFloat(passwordField.frame.size.width), y: CGFloat(5), width: CGFloat(120), height: CGFloat(35))
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "#very_light_pink")?.cgColor
        button.addTarget(self, action: #selector(self.remind), for: .touchUpInside)
        
        passwordField.rightView = button
        passwordField.rightViewMode = .always
        
        emailField.addTarget(self, action: #selector(emailFieldEditingDidBegin(_:)), for: .editingDidBegin)
        emailField.addTarget(self, action: #selector(emailFieldEditingDidEnd(_:)), for: .editingDidEnd)
        passwordField.addTarget(self, action: #selector(passwordFieldEditingDidBegin(_:)), for: .editingDidBegin)
        passwordField.addTarget(self, action: #selector(passwordFieldEditingDidEnd(_:)), for: .editingDidEnd)
    }
    
    @objc func emailFieldEditingDidBegin(_ textField: UITextField) {
        emailLabel.isHidden = false
        emailField.placeholder = ""
    }
    
    @objc func emailFieldEditingDidEnd(_ textField: UITextField) {
        if (emailField.text?.count ?? 0 == 0) {
            emailLabel.isHidden = true
            emailField.placeholder = "Почта"
        }
    }
    
    @objc func passwordFieldEditingDidBegin(_ textField: UITextField) {
        passwordLabel.isHidden = false
        passwordField.placeholder = ""
    }
    
    @objc func passwordFieldEditingDidEnd(_ textField: UITextField) {
        if (passwordField.text?.count ?? 0 == 0) {
            passwordLabel.isHidden = true
            passwordField.placeholder = "Почта"
        }
    }
    
    @IBAction func remind(_ sender: Any) {
        var message = "Если Вы забыли пароль, пожалуйста, введите Ваш e-mail и Вам будет отправлено сообщение с новым паролем."
        
        validationLabel.text = ""
        
        if (emailField.text?.isValidEmail)!{
            message = "Новый пароль будет отправлен на указанный адрес электронной почты."
        }
        
        let alert = UIAlertController(title: "Восстановление пароля", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
}

extension UITextField {
    func setBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height + 5, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(named: "#very_light_pink")?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
