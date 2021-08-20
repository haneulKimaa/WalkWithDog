//
//  UserInfoViewController.swift
//  WalkWithDog-story
//
//  Created by 김하늘 on 2020/12/16.
//

import UIKit
import Firebase
import GoogleSignIn

class UserInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var birthError: UILabel!
    @IBOutlet weak var sexError: UILabel!
    @IBOutlet weak var weightError: UILabel!
    @IBOutlet weak var heightError: UILabel!
    let normalFont = UIFont(name: "AppleSDGothicNeo", size: 18)
    let errorFont = UIFont(name: "Apple SD Gothic Neo", size: 11)
    let numberToolbar: UIToolbar = UIToolbar()
    let numberToolbar2: UIToolbar = UIToolbar()
    //let remoteconfg = Remote
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            birthTextField.becomeFirstResponder()
            if nameTextField.text == ""{
                nameError.text = "필수 입력 항목입니다."
            }
            else{
                nameError.text = ""
            }
        }
        else if textField == birthTextField{
            sexTextField.becomeFirstResponder()
            if birthTextField.text == ""{
                birthError.text = "필수 입력 항목입니다."
            }
            else{
                birthError.text = ""
            }
        }
        else if textField == sexTextField{
            weightTextField.becomeFirstResponder()
            if sexTextField.text == ""{
                sexError.text = "필수 입력 항목입니다."
            }
            else{
                sexError.text = ""
            }
        }
        else if textField == weightTextField{
            heightTextField.becomeFirstResponder()
            
        }
        
        return true
    }
    @objc func makeBMI(){
            heightTextField.resignFirstResponder()
            if heightTextField.text == ""{
                heightError.text = "필수 입력 항목입니다."
            }
            else{
                heightError.text = ""
                var a =  Double(heightTextField.text!)!/100
                var heightMeter = a*a
                var result = Double(weightTextField.text!)!/heightMeter
                bmiLabel.text = String(round(result * 10)/10)
            }
    }
    @objc func makeWeight(){
            heightTextField.becomeFirstResponder()
        if weightTextField.text == ""{
            weightError.text = "필수 입력 항목입니다."
        }
        else{
            weightError.text = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //view.backgroundColor = .white
        //view.layer
        
        //number pad tool bar
        numberToolbar.items = [ UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(makeBMI))]
        numberToolbar2.items = [ UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(makeWeight))]
        numberToolbar.sizeToFit()
        numberToolbar2.sizeToFit()
        heightTextField.inputAccessoryView = numberToolbar
        weightTextField.inputAccessoryView = numberToolbar2
        
        label.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        

        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        if Auth.auth().currentUser != nil{
            print("얼쑤")
        }
        
        //background color
        nameTextField.backgroundColor = .white
        birthTextField.backgroundColor = .white
        sexTextField.backgroundColor = .white
        weightTextField.backgroundColor = .white
        heightTextField.backgroundColor = .white
        
        //placehold
        nameTextField.placeholder = "이름"
        birthTextField.placeholder = "생년월일"
        sexTextField.placeholder = "성별"
        weightTextField.placeholder = "체중 (kg)"
        heightTextField.placeholder = "키 (cm)"
        bmiLabel.text = "체중과 키를 모두 입력하세요."
        
        
        //font
        nameTextField.font = normalFont
        birthTextField.font = normalFont
        sexTextField.font = normalFont
        weightTextField.font = normalFont
        heightTextField.font = normalFont
        bmiLabel.font = normalFont
        bmiLabel.textColor = .gray
        
        nameError.font = errorFont
        nameError.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        birthError.font = errorFont
        birthError.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        sexError.font = errorFont
        sexError.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        weightError.font = errorFont
        weightError.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        heightError.font = errorFont
        heightError.textColor = UIColor(red: 0, green: 0.659, blue: 0.612, alpha: 1)
        
        
        //borderstyle
        nameTextField.borderStyle = .none
        birthTextField.borderStyle = .none
        sexTextField.borderStyle = .none
        weightTextField.borderStyle = .none
        heightTextField.borderStyle = .none
        
        //border radius
        nameTextField.layer.cornerRadius = 13.0
        birthTextField.layer.cornerRadius = 13.0
        sexTextField.layer.cornerRadius = 13.0
        weightTextField.layer.cornerRadius = 13.0
        heightTextField.layer.cornerRadius = 13.0
        
        //left padding
        nameTextField.setLeftPaddingPoints(10)
        birthTextField.setLeftPaddingPoints(10)
        sexTextField.setLeftPaddingPoints(10)
        weightTextField.setLeftPaddingPoints(10)
        heightTextField.setLeftPaddingPoints(10)
        
        
    }
    override func viewDidLoad() {
        
        //Analytics.setUserProperty(<#T##value: String?##String?#>, forName: <#T##String#>)
        


        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: false, completion: nil)
        }catch let signOutError as NSError{
            print("signout error")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
