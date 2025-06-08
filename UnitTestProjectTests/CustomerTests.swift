//
//  CustomerTests.swift
//  UnitTestProjectTests
//
//  Created by SHIN YOON AH on 6/7/25.
//

import Testing

struct Product {
    let id: String
    let name: String
    let price: Double
}

protocol StoreGatewayRepository: Actor {
    func fetchProducts(id: String) -> [Product]
    func addShoppingCartProduct(_ product: Product)
    func resetShoppingCart()
    func purchaseShoppingCart() -> Bool
    func sendReceipt()
}

final actor MockStoreGatewayRepository: StoreGatewayRepository {
    
    private(set) var shoppingCart: [Product]
    private let dummyProducts: [Product]
    private(set) var isReceiptSent: Bool?
    private var isSuccess: Bool
    
    init(
        shoppingCart: [Product] = [],
        storedProducts: [Product] = [],
        isSuccess: Bool = true
    ) {
        self.shoppingCart = shoppingCart
        self.dummyProducts = storedProducts
        self.isSuccess = isSuccess
    }
    
    func fetchProducts(id: String) -> [Product] {
        return dummyProducts.filter { $0.id == id }
    }
    
    func addShoppingCartProduct(_ product: Product) {
        shoppingCart.append(product)
    }
    
    func resetShoppingCart() {
        shoppingCart.removeAll()
    }
    
    func purchaseShoppingCart() -> Bool {
        return isSuccess
    }
    
    func sendReceipt() {
        self.isReceiptSent = true
    }
}

final actor CustomerUseCase {
    
    private let repository: StoreGatewayRepository
    
    init(repository: StoreGatewayRepository) {
        self.repository = repository
    }
    
    func addProductToCart(_ productId: String) async {
        let products = await repository.fetchProducts(id: productId)
        if products.count > 0 {
            await repository.addShoppingCartProduct(products.first!)
        } else {
            await repository.resetShoppingCart()
        }
    }
    
    func purchaseShoppingCart() async {
        guard await repository.purchaseShoppingCart() else {
            await repository.resetShoppingCart()
            return
        }
        await repository.sendReceipt()
    }
}

struct CustomerTests {
    
    private let mock: MockStoreGatewayRepository
    private let sut: CustomerUseCase
    
    init() {
        // given
        let shoppingCart: [Product] = [
            Product(id: "35", name: "Test Banana", price: 0)
        ]
        let preparedProducts: [Product] = [
            Product(id: "1", name: "Test Product", price: 0),
            Product(id: "20", name: "Test Shoes", price: 0),
            Product(id: "100", name: "Test Bags", price: 0)
        ]
        self.mock = MockStoreGatewayRepository(
            shoppingCart: shoppingCart,
            storedProducts: preparedProducts
        )
        self.sut = CustomerUseCase(repository: mock)
    }
    
    @Test("재고가 있는 상품일 경우 장바구니에 추가한다.")
    func test_add_shopping_cart() async {
        // given
        let addedProductId = "100"
        // when
        await sut.addProductToCart(addedProductId)
        // then
        await #expect(mock.shoppingCart.contains(where: { $0.id == addedProductId }))
    }
    
    @Test("재고가 없는 상품일 경우 장바구니를 비운다.")
    func test_reset_shopping_cart() async {
        // when
        await sut.addProductToCart("30")
        // then
        await #expect(mock.shoppingCart.isEmpty)
    }
    
    @Test("유저가 상품 구매를 성공한다.")
    func test_purchase_success() async {
        // given
        let shoppingCart: [Product] = [
            Product(id: "35", name: "Banana", price: 125_000),
            Product(id: "40", name: "Apple", price: 5_000),
            Product(id: "40", name: "Apple", price: 5_000),
            Product(id: "40", name: "Apple", price: 5_000),
            Product(id: "37", name: "Orange", price: 10_000),
        ]
        let mock = MockStoreGatewayRepository(
            shoppingCart: shoppingCart,
            isSuccess: true
        )
        let sut = CustomerUseCase(repository: mock)
        // when
        await sut.purchaseShoppingCart()
        // then
        await #expect(mock.isReceiptSent!)
    }
    
    @Test("유저가 상품 구매를 실패한다.")
    func test_purchase_fail() async {
        // given
        let shoppingCart: [Product] = [
            Product(id: "35", name: "Banana", price: 125_000),
            Product(id: "35", name: "Apple", price: 5_000),
            Product(id: "35", name: "Apple", price: 5_000),
            Product(id: "35", name: "Apple", price: 5_000),
            Product(id: "35", name: "Orange", price: 10_000),
        ]
        let mock = MockStoreGatewayRepository(
            shoppingCart: shoppingCart,
            isSuccess: false
        )
        let sut = CustomerUseCase(repository: mock)
        // when
        await sut.purchaseShoppingCart()
        // then
        await #expect(mock.shoppingCart.isEmpty)
    }
}
