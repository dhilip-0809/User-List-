
//

import UIKit


/*
 In a live streaming app, we want to show the top N active viewers based on the number of messages they’ve sent during the stream.
 You need to create a simple iOS app where:
 * The user can enter a list of viewers and their message counts (like "Alice:10, Bob:25, Charlie:3, David:17, Eva:20").
 * The user also inputs a number N.
 * On tapping “Find Top N”, the app displays the names of the top N active viewers.
 
 * Given a list of (username, messageCount) pairs and an integer N,
 * return the top N users with the highest messageCount.
 
 Example Input:
 Users: Alice:10, Bob:25, Charlie:3, David:17, Eva:20
 N = 3
 
 Expected Output:
 ["Bob", "Eva", "David"]
 
 */


class ViewController: UIViewController, UITextFieldDelegate {
    
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Enter input"
        tf.delegate = self
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Find Top N", for : .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
    }
    
    func setUpViews() {
        self.view.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(button)
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
    }
}



class Presenter {
    func findTopNusers(list: [User], n: Int) {
        
        var dummy: [Int] = []
        var ouput: [String] = []
        let anotherDummy = list.sorted { $0.age > $1.age }
            .prefix(n)
            .map { $0.name }
        print(anotherDummy)
        for user in list {
            dummy.append(user.age)
        }
        dummy = dummy.sorted(by: >)
        
        for i in 0 ..< n {
            if i < dummy.count {
                
                let age = dummy[i]
                
                if let res = list.first(where: { $0.age == age && !ouput.contains($0.name) }) {
                    ouput.append(res.name)
                }
            }
        }
        print(ouput)
    }
}

struct User {
    let age: Int
    let name: String
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

