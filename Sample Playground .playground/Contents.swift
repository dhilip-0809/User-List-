import UIKit

// Grand central Dispatch Queue


DispatchQueue.main.async {
    
}

struct User {
    let name: String
    let age: Int
}


@MainActor
func setupUI()  {
    
    let tablleView = UITableView()
    
    Task {
        let users = await fetchdataFromServers()
    }
    
    tablleView.reloadData()
}

func fetchdataFromServers() async -> [User]{
    return []
}


    
    
   

