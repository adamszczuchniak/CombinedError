//
//  Created by Adam Szczuchniak
//

// MARK: - TWO ERRORS COMBINED

public struct CombinedError<E1: Error, E2: Error>: Error {
    let error1: E1?
    let error2: E2?

    public init(error1: E1?, error2: E2?) {
        self.error1 = error1
        self.error2 = error2
    }

    public var values: (E1?, E2?) {
        (error1, error2)
    }
}

// MARK: - THREE ERRORS COMBINED

public struct CombinedError3<E1: Error, E2: Error, E3: Error>: Error {
    let error1: E1?
    let error2: E2?
    let error3: E3?

    public init(error1: E1?, error2: E2?, error3: E3?) {
        self.error1 = error1
        self.error2 = error2
        self.error3 = error3
    }

    public var values: (E1?, E2?, E3?) {
        (error1, error2, error3)
    }
}

// MARK: - FOUR ERRORS COMBINED

public struct CombinedError4<E1: Error, E2: Error, E3: Error, E4: Error>: Error {
    let error1: E1?
    let error2: E2?
    let error3: E3?
    let error4: E4?

    public init(error1: E1?, error2: E2?, error3: E3?, error4: E4?) {
        self.error1 = error1
        self.error2 = error2
        self.error3 = error3
        self.error4 = error4
    }

    public var values: (E1?, E2?, E3?, E4?) {
        (error1, error2, error3, error4)
    }
}
