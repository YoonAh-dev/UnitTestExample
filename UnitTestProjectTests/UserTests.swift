//
//  UserTests.swift
//  UnitTestProjectTests
//
//  Created by SHIN YOON AH on 6/6/25.
//

import Foundation
import Testing

protocol EmailGatewayRepository: Actor {
    func sendEmail(_ email: String, content: String)
    func fetchMailContents() -> [String]
}

final actor MockEmailGatewayRepository: EmailGatewayRepository {
    
    private(set) var sentEmail: String?
    
    private let mailContents: [String]
    
    init(mailContents: [String] = []) {
        self.mailContents = mailContents
    }
    
    func sendEmail(_ email: String, content: String) {
        sentEmail = email
    }
    
    func fetchMailContents() -> [String] {
        return mailContents
    }
}

protocol UserInfoGatewayRepository: Actor {
    func patchUsername(_ username: String)
}

final actor MockUserInfoGatewayRepository: UserInfoGatewayRepository {
    
    private(set) var username: String?
    
    func patchUsername(_ username: String) {
        self.username = username
    }
}

final actor UserUseCase {
    
    private let maxLength = 10
    
    private let emailRepository: EmailGatewayRepository?
    private let userInfoRepository: UserInfoGatewayRepository?
    
    init(
        emailRepository: EmailGatewayRepository? = nil,
        userInfoRepository: UserInfoGatewayRepository? = nil
    ) {
        self.emailRepository = emailRepository
        self.userInfoRepository = userInfoRepository
    }
    
    func greetUser(_ email: String) async {
        await emailRepository?.sendEmail(email, content: "Hi there! welcome to our app!")
    }
    
    func fetchMailContentsCount() async -> Int {
        return await emailRepository?.fetchMailContents().count ?? 0
    }
    
    func updateUsername(_ name: String) async {
        let trimmedUsername = trimUsernameToMaxLength(name)
        await userInfoRepository?.patchUsername(trimmedUsername)
    }
    
    private func trimUsernameToMaxLength(_ name: String) -> String {
        return name.count > maxLength ? String(name.prefix(maxLength)) : name
    }
}

struct UserTests {
    @Test("유저에게 인사 이메일을 보내는 기능")
    func test_sending_a_greeting_email() async {
        // given
        let mock = MockEmailGatewayRepository()
        let sut = UserUseCase(emailRepository: mock)
        let userEmail = "test@example.com"
        // when
        await sut.greetUser(userEmail)
        // then
        await #expect(mock.sentEmail == "test@example.com")
    }
    
    @Test("유저가 생성한 메일의 개수 확인 기능")
    func test_created_mail_count() async {
        // given
        let stub = MockEmailGatewayRepository(mailContents: ["test1", "test2", "test3"])
        let sut = UserUseCase(emailRepository: stub)
        // when
        let contentsCount = await sut.fetchMailContentsCount()
        // then
        #expect(3 == contentsCount)
    }
    
    @Test("유저 이름 변경 시 도메인 룰에 따라 이름 변경 > 최대 10자")
    func test_update_username() async {
        // given
        let mock = MockUserInfoGatewayRepository()
        let sut = UserUseCase(userInfoRepository: mock)
        // when
        await sut.updateUsername("Christabella")
        // then
        await #expect(mock.username == "Christabel")
    }
}
