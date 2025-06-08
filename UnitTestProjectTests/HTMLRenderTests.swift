//
//  HTMLRenderTests.swift
//  UnitTestProjectTests
//
//  Created by SHIN YOON AH on 5/26/25.
//

import Testing

struct Message {
    let header: String
    let body: String
    let footer: String
}

protocol Render {
    func render(message: Message) -> String
}

class HTMLRender: Render {
    var subRenders: [Render] = [
        HeaderRender(),
        BodyRender(),
        FooterRender()
    ]
    
    func render(message: Message) -> String {
        return subRenders.map { $0.render(message: message) }.joined()
    }
}

class HeaderRender: Render {
    func render(message: Message) -> String {
        return "<h1>\(message.header)</h1>"
    }
}

class BodyRender: Render {
    func render(message: Message) -> String {
        return "<b>\(message.body)</b>"
    }
}

class FooterRender: Render {
    func render(message: Message) -> String {
        return "<p>\(message.footer)</p>"
    }
}

struct HTMLRenderTests {

    @Test
    func test_render_proper_html() async throws {
        // given
        let sut = HTMLRender()
        let header = "Hello World"
        let body = "Body Part"
        let footer = "BYE World"
        // when
        let renders = sut.render(message: Message(header: header, body: body, footer: footer))
        // then
        #expect(renders == "<h1>\(header)</h1><b>\(body)</b><p>\(footer)</p>")
    }

}
