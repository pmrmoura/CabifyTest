import XCTest
import Combine
@testable import CabifyTest

final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var subscriptions = [AnyCancellable]()
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        subscriptions = []
        super.tearDown()
    }
    
    
    func testExecuteCartOperationAddProduct() {
//        let product = Product(code: "dede", name: "pedro", price: 91.0)
//        viewModel.executeCartOperation(.addProduct(product: product))
//
//        XCTAssertTrue(viewModel.cart.products.contains(product))
        
        let discountService = DiscountServiceStub()
        discountService.fetchAllDiscounts()
            .sink(receiveCompletion: {result in
                print(result)
            }, receiveValue: { result in
                print(result)
            })
            .store(in: &subscriptions)
    }
}
