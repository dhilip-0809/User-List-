import XCTest
@testable import UserLookUp

final class UserLookUpTests: XCTestCase {
    
    var usersListPresenter: UsersListPresenter!
    var userPostsPresenter: UserPostsPresenter!
    var mockUsersListView: MockUsersListView!
    var mockUserPostsView: MockUserPostsView!
    var mockUsersListDataManager: MockUsersListDataManager!
    var mockUserPostsDataManager: MockUserPostsDataManager!
    var mockRouter: MockUsersListRouter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUsersListView = MockUsersListView()
        mockUserPostsView = MockUserPostsView()
        mockUsersListDataManager = MockUsersListDataManager()
        mockUserPostsDataManager = MockUserPostsDataManager()
        mockRouter = MockUsersListRouter()
        
        usersListPresenter = UsersListPresenter(view: mockUsersListView, dataManager: mockUsersListDataManager, router: mockRouter)
        userPostsPresenter = UserPostsPresenter(view: mockUserPostsView, dataManager: mockUserPostsDataManager, userId: 1)
    }
    
    override func tearDownWithError() throws {
        usersListPresenter = nil
        userPostsPresenter = nil
        mockUsersListView = nil
        mockUserPostsView = nil
        mockUsersListDataManager = nil
        mockUserPostsDataManager = nil
        mockRouter = nil
        try super.tearDownWithError()
    }
    
    func testViewDidLoad_CallsFetchUsers() {
        usersListPresenter.viewDidLoad()
        
        XCTAssertTrue(mockUsersListView.showLoadingCalled)
        XCTAssertTrue(mockUsersListDataManager.fetchUsersCalled)
    }
    
    func testFetchUsers_Success_ShowsUsers() {
        let expectation = expectation(description: "Fetch users")
        mockUsersListDataManager.usersToReturn = [TestData.sampleUser]
        
        usersListPresenter.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.mockUsersListView.hideLoadingCalled)
            XCTAssertTrue(self.mockUsersListView.showUsersCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchAndSelectUser_NavigatesToDetail() {
        let expectation = expectation(description: "Search and select")
        
        let user1 = User(id: 1, name: "Leanne Graham", username: "Bret", email: "test@test.com",
            phone: "123", website: "test.com", address: Address(street: "St", suite: "1", city: "City", zipcode: "123"),
            company: Company(name: "Co", catchPhrase: "Phrase", bs: "BS"))
        
        let user2 = User(id: 2, name: "Ervin Howell", username: "Antonette", email: "test2@test.com",
            phone: "456", website: "test2.com", address: Address(street: "St2", suite: "2", city: "City2", zipcode: "456"),
            company: Company(name: "Co2", catchPhrase: "Phrase2", bs: "BS2"))
        
        mockUsersListDataManager.usersToReturn = [user1, user2]
        usersListPresenter.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.usersListPresenter.didSearchUsers(with: "Lea")
            
            XCTAssertEqual(self.usersListPresenter.numberOfUsers, 1, "Should find 1 user with 'Lea'")
            
            self.usersListPresenter.didSelectUser(at: 0)
            
            XCTAssertTrue(self.mockRouter.navigateToUserDetailCalled, "Should navigate")
            XCTAssertEqual(self.mockRouter.passedUser?.name, "Leanne Graham", "Should pass Leanne")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchPosts_Success_ShowsPosts() {
        let expectation = expectation(description: "Fetch posts")
        mockUserPostsDataManager.postsToReturn = [TestData.samplePost]
        
        userPostsPresenter.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.mockUserPostsView.hideLoadingCalled)
            XCTAssertTrue(self.mockUserPostsView.showPostsCalled)
            XCTAssertEqual(self.userPostsPresenter.numberOfPosts, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

class MockUsersListView: UsersListViewContract {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showUsersCalled = false
    var showErrorCalled = false
    
    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }
    func showUsers(_ users: [User]) { showUsersCalled = true }
    func showError(_ message: String) { showErrorCalled = true }
}

class MockUserPostsView: UserPostsViewContract {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showPostsCalled = false
    var showErrorCalled = false
    
    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }
    func showPosts(_ posts: [Post]) { showPostsCalled = true }
    func showError(_ message: String) { showErrorCalled = true }
}

class MockUsersListDataManager: UsersListDataManagerContract {
    var fetchUsersCalled = false
    var usersToReturn: [User] = []
    
    func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void) {
        fetchUsersCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            successBlock(self.usersToReturn)
        }
    }
}

class MockUserPostsDataManager: UserPostsDataManagerContract {
    var fetchPostsCalled = false
    var postsToReturn: [Post] = []
    
    func fetchPosts(userId: Int, successBlock: @escaping ([Post]) -> Void, failureBlock: @escaping (UserPostsError) -> Void) {
        fetchPostsCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            successBlock(self.postsToReturn)
        }
    }
}

class MockUsersListRouter: UsersListRouterContract {
    var navigateToUserDetailCalled = false
    var passedUser: User?
    
    func navigateToUserDetail(user: User) {
        navigateToUserDetailCalled = true
        passedUser = user
    }
}

struct TestData {
    static let sampleUser = User(
        id: 1, name: "Leanne Graham", username: "Bret", email: "test@test.com",
        phone: "1-770-736-8031 x56442", website: "123",
        address: Address(street: "St", suite: "1", city: "City", zipcode: "123"),
        company: Company(name: "Co", catchPhrase: "Phrase", bs: "BS")
    )
    
    static let samplePost = Post(id: 1, userId: 1, title: "Test Post", body: "Test body")
}
