import XCTest
import Combine
@testable import CombinedErrors

final class CombinedErrorsTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        cancellables = []
    }
    
    func testCombinedErrors() {
        // MARK: - SETUP PUBLISHERS

        let networkPublisher = PassthroughSubject<Int, NetworkError>()

        let databasePublisher = PassthroughSubject<Int, DatabaseError>()

        let joinedPublishers: AnyPublisher<Int, NetworkDatabaseErrors> =
        // Map networkPublisher error to CombinedError struct
        networkPublisher.combineErrors()
            .flatMap { network in
                // Map databasePublisher error to CombinedError struct
                return databasePublisher.combineErrors()
            }
            .eraseToAnyPublisher()

        // MARK: - OBSERVE PUBLISHERS

        networkPublisher
            .handleEvents(receiveOutput: { value in
                if value % 2 != 0 {
                    networkPublisher.send(completion: .failure(.networkErrorExample))
                }
            })
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("networkPublisher completed successfully")
                    case .failure(let error):
                        print("networkPublisher encountered an error: \(error)")
                    }
                },
                receiveValue: { value in
                    print("networkPublisher Received value: \(value)")
                }
            ).store(in: &cancellables)

        databasePublisher
            .handleEvents(receiveOutput: { value in
                if value % 2 != 0 {
                    databasePublisher.send(completion: .failure(.databaseErrorExample))
                }
            })
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("databasePublisher completed successfully")
                    case .failure(let error):
                        switch error {
                        case .databaseErrorExample:
                            print("databasePublisher encountered an error: \(error)")
                        }
                    }
                },
                receiveValue: { value in
                    print("databasePublisher Received value: \(value)")
                }
            ).store(in: &cancellables)

        joinedPublishers
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case let .failure(combinedError):
                    // errors parameter is NetworkDatabaseErrors aka CombinedError<NetworkError, DatabaseError>

                    // fetching error via variable, in this example error2 is optional DatabaseError
                    let error2 = combinedError.error2
                    XCTAssertTrue(error2 == .databaseErrorExample)

                    // fetching error via tuple values, in this example error1 is optional NetworkError
                    let (error1, _) = combinedError.values
                    XCTAssertNil(error1)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        // MARK: - SEND MOCK DATA

        networkPublisher.send(2) // network request will succeed
        databasePublisher.send(5) // database call will fail
    }

}

// MARK: - ERROR MODELS EXAMPLES

/// Naming convention for CombinedError struct for better readability
fileprivate typealias NetworkDatabaseErrors = CombinedError<NetworkError, DatabaseError>

fileprivate enum NetworkError: Error {
    case networkErrorExample
}

fileprivate enum DatabaseError: Error {
    case databaseErrorExample
}

