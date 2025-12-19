import UIKit

var greeting = "Hello, playground"


class Presenter {
    
    // "Alice:10, Bob:25, Charlie:3, David:17, Eva:20"
    
    
    /*
     In a live streaming app, we want to show the top N active viewers based on the number of messages they’ve sent during the stream.
     You need to create a simple iOS app where:
     * The user can enter a list of viewers and their message counts (like "Alice:10, Bob:25, Charlie:3, David:17, Eva:20").
     * The user also inputs a number N.
     * On tapping “Find Top N”, the app displays the names of the top N active viewers.
     
     Core DSA Problem
     * Given a list of (username, messageCount) pairs and an integer N,
     * return the top N users with the highest messageCount.
     
     Example Input:
     Users: Alice:10, Bob:25, Charlie:3, David:17, Eva:20
     N = 3
     
     Expected Output:
     ["Bob", "Eva", "David"]
     
     */
    

    
    
    
    func findTopNusers(list: [User], n: Int) {

        let result = list
            .sorted { $0.age > $1.age }
            .prefix(n)
            .map { $0.name }

        print(result)

        var dummy: [Int] = []
        var output: [String] = []

        for user in list {
            dummy.append(user.age)
        }

        dummy.sort(by: >)

        for i in 0..<min(n, dummy.count) {

            let age = dummy[i]

            if let res = list.first(where: {
                $0.age == age && !output.contains($0.name)
            }) {
                output.append(res.name)
            }
        }

        print(output)
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

let p = Presenter()

let one = User(name: "Alice", age: 10)
let two = User(name: "Bob", age: 34)
let three = User(name: "Charlie", age: 76)
let four = User(name: "David", age: 34)
let list = [one, two, three, four]

p.findTopNusers(list: list, n: 3)
