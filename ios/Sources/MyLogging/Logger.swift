import Foundation

public struct Logger {
    public struct Message: Equatable {
        public var level: Level
        public var message: String
        public var date: Date

        public init(level: Level, message: String, date: Date) {
            self.level = level
            self.message = message
            self.date = date
        }
    }

    private var handler: LogHandler
    private var dateProvider: () -> Date
    public var logLevel: Level = .info

    public init(handler: LogHandler, dateProvider: @escaping () -> Date) {
        self.handler = handler
        self.dateProvider = dateProvider
    }

    public init(handler: LogHandler) {
        self.init(handler: handler, dateProvider: { Date() })
    }
}

public extension Logger {
    func log(_ msg: Message) {
        guard handler.logLevel.shouldLog(msg.level) else {
            return
        }
        handler.log(msg)
    }

    func log(level: Level, message: String) {
        let date = dateProvider()
        let msg = Message(level: level, message: message, date: date)
        log(msg)
    }

    func info(_ message: @autoclosure () -> String) {
        log(level: .info, message: message())
    }

    func warning(_ message: @autoclosure () -> String) {
        log(level: .warning, message: message())
    }

    func error(_ message: @autoclosure () -> String) {
        log(level: .error, message: message())
    }
}
