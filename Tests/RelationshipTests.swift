/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import XCTest
@testable import Graph

class RelationshipTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    var delegateException: XCTestExpectation?
    var groupExpception: XCTestExpectation?
    var propertyExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultGraph() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T")
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testNamedGraphSave() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph(name: "RelationshipTests-testNamedGraphSave")
        
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T", graph: "RelationshipTests-testNamedGraphSave")
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testReferenceGraphSave() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph(name: "RelationshipTests-testReferenceGraphSave")
        
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T", graph: graph)
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testAsyncGraphSave() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph(name: "RelationshipTests-testAsyncGraphSave")
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T", graph: graph)
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testAsyncGraphDelete() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T")
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        relationship.delete()
        
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testSubject() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T")
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        
        let subject = Entity(type: "T")
        relationship.subject = subject
        
        XCTAssertEqual(subject, relationship.subject)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testObject() {
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[RelationshipTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[RelationshipTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T")
        relationship["P"] = "V"
        relationship.addToGroup("G")
        
        XCTAssertEqual("V", relationship["P"] as? String)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[RelationshipTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[RelationshipTests Error: Delegate test failed.]")
        
        let object = Entity(type: "T")
        relationship.object = object
        
        XCTAssertEqual(object, relationship.object)
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertRelationship(graph: Graph, relationship: Relationship) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("V", relationship["P"] as? String)
        XCTAssertTrue(relationship.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphDidUpdateRelationship(graph: Graph, relationship: Relationship) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("V", relationship["P"] as? String)
        XCTAssertTrue(relationship.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphDidDeleteRelationship(graph: Graph, relationship: Relationship) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertNil(relationship["P"])
        XCTAssertFalse(relationship.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphDidInsertRelationshipGroup(graph: Graph, relationship: Relationship, group: String) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertTrue(relationship.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphDidDeleteRelationshipGroup(graph: Graph, relationship: Relationship, group: String) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertFalse(relationship.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, relationship[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, relationship[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphDidDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(relationship["P"])
        
        propertyExpception?.fulfill()
    }
}