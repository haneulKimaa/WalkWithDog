//
//  logInViewController.swift
//  WalkWithDog-story
//
//  Created by 김하늘 on 2020/12/13.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoSDKAuth
import KakaoOpenSDK
import Alamofire

class logInViewController: UIViewController, GIDSignInDelegate {

    var handle: AuthStateDidChangeListenerHandle?
    //구글은 view, 카카오는 button
    @IBOutlet weak var googleBtn: GIDSignInButton!
    @IBOutlet weak var kakaoBtn: KOLoginButton!
    @IBOutlet weak var introduceLabel: UILabel!
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        self.view.addSubview(googleBtn)
        self.view.addSubview(kakaoBtn)
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        introduceLabel.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 14)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleLoginBtn(_ sender: UIButton) {
        //GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func kakaoLoginBtn(_ sender: UIButton) {
        
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            session.close()
        }
        session.open{ (error) in
            if error != nil || !session.isOpen(){
                print("kakao : fail to login")
                return
            }
            self.requestKakao(accessToken: session.token!.accessToken)
            
            
        }
//        session.open(completionHandler: { (error) -> Void in
//
//            if !session.isOpen() {
//
//                if let error = error as NSError? {
//                    switch error.code {
//                    case Int(KOErrorCancelled.rawValue):
//                        break
//                    default:
//                        print("오류")
//                    }
//                }
//            } else {
//                self.requestKakao(accessToken: session.token!.accessToken)
//                self.present(self, animated: true)
//            }
//        })
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      // ...
        //firebase에 로그인 정보 fetch
        Auth.auth().signIn(with: credential){(user, error) in
            if let error = error{
                return
            }
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "userInfoVC")
            VC?.modalPresentationStyle = .fullScreen
            VC?.modalTransitionStyle = .flipHorizontal
            self.dismiss(animated: false, completion: nil)
            self.present(VC!, animated: true, completion: nil)

            
            print("done")
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func requestKakao(accessToken: String) {
            let url = URL(string: String(format: "%@/verifyToken", Bundle.main.object(forInfoDictionaryKey: "VALIDATION_SERVER_URL") as! String))!
            let parameters: [String: String] = ["token": accessToken]
            let req = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            req.responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("success: requestKakao")
                    guard let object = value as? [String: Any] else {
                        return
                    }
                    guard let firebaseToken = object["firebase_token"]  else { return }
                    self.signInToFirebaseWithToken(firebaseToken: firebaseToken as! String )
                case .failure(let error):
                    print("error : requestkakao",error)
                }
                
            }
        }
    func signInToFirebaseWithToken(firebaseToken: String) {
        Auth.auth().signIn(withCustomToken: firebaseToken) { (user, error) in
          // ...
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
