//
//  Created by Adam Szczuchniak
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    // MARK: - TWO ERRORS COMBINED

    func combineErrors<E1: Error, E2: Error>() -> Publishers.MapError<Self, CombinedError<E1, E2>> {
        mapError { error in
            let error1 = error as? E1
            let error2 = error as? E2
            return CombinedError(error1: error1, error2: error2)
        }
    }

    // MARK: - THREE ERRORS COMBINED

    func combineErrors<E1: Error, E2: Error, E3: Error>() -> Publishers.MapError<Self, CombinedError3<E1, E2, E3>> {
        mapError { error in
            let error1 = error as? E1
            let error2 = error as? E2
            let error3 = error as? E3
            return CombinedError3(error1: error1, error2: error2, error3: error3)
        }
    }

    // MARK: - FOUR ERRORS COMBINED

    func combineErrors<E1: Error, E2: Error, E3: Error, E4: Error>() -> Publishers.MapError<Self, CombinedError4<E1, E2, E3, E4>> {
        mapError { error in
            let error1 = error as? E1
            let error2 = error as? E2
            let error3 = error as? E3
            let error4 = error as? E4
            return CombinedError4(error1: error1, error2: error2, error3: error3, error4: error4)
        }
    }
}
