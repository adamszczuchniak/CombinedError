# CombinedError
Solution how to aggregate different error types in Combine library

## Installation

Install with Swift Package Manager

```
https://github.com/adamszczuchniak/CombinedError
```

## Usage 
Common example of Publishers with different error types will be sending network request and then storing it's result in database.

Assuming that you have:
```swift
    let networkPublisher = PassthroughSubject<Int, NetworkError>()
        
    let databasePublisher = PassthroughSubject<Int, DatabaseError>()
```

In Above exaple we have two different error types `NetworkError` and `DatabaseErorr` 
To combine both these errors into single Error use struct `CombinedEror` (there are also structs `CombinedError3`, and `CombinedError4` for three and four different errors)

```swift 
    let joinedPublishers: AnyPublisher<Int, CombinedError<NetworkError, DatabaseError> > =
    // Map networkPublisher error to CombinedError struct
    networkPublisher.combineErrors()
        .flatMap { network in
            // Map databasePublisher error to CombinedError struct
            return databasePublisher.combineErrors()
        }
        .eraseToAnyPublisher()
```

`Publisher` extension function `combineErrors()` will map error to specified `CombinedError`

Accessing stored error can be done via variable `error1`, `error2`, etc or via tuple `values` 

## Example

Example usage can be found in `CombinedErrorsTests` file

## Author

- Adam Szczuchniak

## License

[MIT](https://github.com/adamszczuchniak/CombinedError?tab=MIT-1-ov-file)
