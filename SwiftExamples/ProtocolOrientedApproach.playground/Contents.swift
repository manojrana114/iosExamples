//: Playground - noun: a place where people can play

import UIKit

protocol Bird : CustomStringConvertible{
    var name: String{get}
    //var canFly :Bool{get}
}

protocol Flyable{
    var airspeedVelocity : Double{get}
}

extension Bird {
    // Flyable birds can fly!
    var canFly: Bool { return self is Flyable }
}

extension Bird{
    var description: String {
        return canFly ? "I can fly" : "Guess I’ll just sit here :["
    }
}

struct FlappyBird:Bird,Flyable{
    
    let name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double
    //let canFly = true
    
    var airspeedVelocity: Double {
        return 3 * flappyFrequency * flappyAmplitude
    }
}


struct Penguin: Bird {
    let name: String
}

struct SwiftBird: Bird, Flyable {
    var name: String { return "Swift \(version)" }
    let version: Double
    
    // Swift is FASTER every version!
    var airspeedVelocity: Double { return version * 1000.0 }
}

enum UnladenSwallow: String ,Bird, Flyable {
    case african = "African"
    case european = "European"
    case unknown = "Uknown"
    
    var name: String {
        switch self {
        case .african:
            return "African"
        case .european:
            return "European"
        case .unknown:
            return "What do you mean? African or European?"
        }
    }
    
    var airspeedVelocity: Double {
        switch self {
        case .african:
            return 10.0
        case .european:
            return 9.9
        case .unknown:
            fatalError("You are thrown from the bridge of death!")
        }
    }
}

let eAfrican = UnladenSwallow.african
eAfrican.airspeedVelocity
eAfrican.canFly


extension UnladenSwallow {
    var canFly: Bool {
        return self != .unknown
    }
}

let rawEnum = UnladenSwallow(rawValue:"Uknown")
rawEnum?.canFly
    
//
let numbers = [10,20,30,40,50,60]
let slice = numbers[1...3]
let reversedSlice = slice.reversed()

let answer = reversedSlice.map { $0 * 10 }
print(answer)

class Motorcycle {
    init(name: String) {
        self.name = name
        speed = 200
    }
    var name: String
    var speed: Double
}

protocol Racer {
    var speed: Double { get }  // speed is the only thing racers care about
}

extension FlappyBird: Racer {
    var speed: Double {
        return airspeedVelocity
    }
}

extension SwiftBird: Racer {
    var speed: Double {
        return airspeedVelocity
    }
}

extension Penguin: Racer {
    var speed: Double {
        return 42  // full waddle speed
    }
}

extension UnladenSwallow: Racer {
    var speed: Double {
        return canFly ? airspeedVelocity : 0
    }
}

extension Motorcycle: Racer {}

let racers: [Racer] =
    [UnladenSwallow.african,
     UnladenSwallow.european,
     UnladenSwallow.unknown,
     Penguin(name: "King Penguin"),
     SwiftBird(version: 3.0),
     FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
     Motorcycle(name: "Giacomo")
]

extension Sequence where Iterator.Element == Racer {
    func topSpeed() -> Double {
        return self.max(by: { $0.speed < $1.speed })?.speed ?? 0
    }
}

racers[1...3].topSpeed()
func == (f:Racer, second:Racer) -> Bool{
    return f.speed > second.speed
}
UnladenSwallow.african == UnladenSwallow.european


// SWift 4.0
class Tutorial: Codable {
    let title: String
    let author: String
    let editor: String
    let type: String
    let publishDate: Date
    
    init(title: String, author: String, editor: String, type: String, publishDate: Date) {
        self.title = title
        self.author = author
        self.editor = editor
        self.type = type
        self.publishDate = publishDate
    }
}

let tutorial = Tutorial(title: "What's New in Swift 4?", author: "Cosmin Pupăză", editor: "Simon Ng", type: "Swift", publishDate: Date())

let encoder = JSONEncoder()
let data = try encoder.encode(tutorial)
let string = String(data: data, encoding: .utf8)

let decoder = JSONDecoder()
let article = try decoder.decode(Tutorial.self, from: data)
let info = "\(article.title) \(article.author) \(article.editor) \(article.type) \(article.publishDate)"
