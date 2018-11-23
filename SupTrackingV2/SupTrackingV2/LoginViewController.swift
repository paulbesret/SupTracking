import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var SupInfoLogo: UIImageView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let login_url = "http://supinfo.steve-colinet.fr/suptracking/"
    
    @IBAction func loginButton(_ sender: UIButton) {
        let username: String = loginTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        login(login: username, password: password)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SupInfoLogo.image = UIImage(named: "SupInfoLogo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login (login:String, password:String) {
        let parameters: Parameters=[
            "action":"login",
            "login":"\(login)",
            "password":"\(password)"
        ]
        print(parameters)
        
        Alamofire.request(login_url, method: .post, parameters: parameters).responseJSON{
            response in
            switch response.result {
            case .success(let data):
                guard let json = data as? [String : AnyObject] else { return }
                let success: Bool = json["success"] as! Bool
                if(success == true){
                    print(json)
                    let username = json["user"]!["username"] as? String ?? "empty"
                    let password = json["user"]!["password"] as? String ?? "empty"
                    // Storing user datas into UserDefaults.standard
                    let userSession = UserDefaults.standard
                    userSession.set(username, forKey: "login")
                    userSession.set(password, forKey: "password")
                    
                    // Performing Segue to next view
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    self.errorMessage.isHidden = false
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

