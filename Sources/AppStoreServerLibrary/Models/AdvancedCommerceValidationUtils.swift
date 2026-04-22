// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

public struct AdvancedCommerceValidationUtils {

    public static let maximumDescriptionLength = 45
    public static let maximumDisplayNameLength = 30
    private static let maximumSkuLength = 128
    private static let minPeriod = 1
    private static let maxPeriod = 12

    ///Validates description is not nil and does not exceed maximum length.
    ///
    /// - Parameter description: the description to validate
    /// - Returns: the validated description
    /// - Throws: if description exceeds maximum length
    public static func validateDescription(_ description: String) throws -> String {
        return try validateString(description, maxLength: maximumDescriptionLength, fieldName: "description")
    }

    ///Validates display name is not nil and does not exceed maximum length.
    ///
    /// - Parameter displayName: the display name to validate
    /// - Returns: the validated display name
    /// - Throws: if display name exceeds maximum length
    public static func validateDisplayName(_ displayName: String) throws -> String {
        return try validateString(displayName, maxLength: maximumDisplayNameLength, fieldName: "displayName")
    }

    ///Validates SKU does not exceed maximum length.
    ///
    /// - Parameter sku: the SKU to validate
    /// - Returns: the validated SKU
    /// - Throws: if SKU exceeds maximum length
    public static func validateSku(_ sku: String) throws -> String {
        guard sku.count <= maximumSkuLength else {
            throw ValidationError.stringTooLong(fieldName: "SKU", maxLength: maximumSkuLength)
        }
        return sku
    }

    ///Validates periodCount is not nil and between `minPeriod` and `maxPeriod` inclusive.
    ///
    /// - Parameter periodCount: the period count to validate
    /// - Returns: the validated period count
    /// - Throws: if periodCount is out of range
    public static func validatePeriodCount(_ periodCount: Int32) throws -> Int32 {
        guard periodCount >= minPeriod && periodCount <= maxPeriod else {
            throw ValidationError.outOfRange(fieldName: "periodCount", min: minPeriod, max: maxPeriod)
        }
        return periodCount
    }

    ///Validates a list of items is not empty and contains no nil elements.
    ///
    /// - Parameter items: the list of items to validate
    /// - Returns: the validated list of items
    /// - Throws: if the list is empty
    public static func validateItems<T>(_ items: [T]) throws -> [T] {
        guard !items.isEmpty else {
            throw ValidationError.emptyList(fieldName: "items")
        }
        return items
    }

    private static func validateString(_ value: String, maxLength: Int, fieldName: String) throws -> String {
        guard value.count <= maxLength else {
            throw ValidationError.stringTooLong(fieldName: fieldName, maxLength: maxLength)
        }
        return value
    }

    public enum ValidationError: Error, CustomStringConvertible {
        case stringTooLong(fieldName: String, maxLength: Int)
        case outOfRange(fieldName: String, min: Int, max: Int)
        case emptyList(fieldName: String)

        public var description: String {
            switch self {
            case .stringTooLong(let fieldName, let maxLength):
                return "\(fieldName) length cannot exceed \(maxLength) characters"
            case .outOfRange(let fieldName, let min, let max):
                return "\(fieldName) must be between \(min) and \(max)"
            case .emptyList(let fieldName):
                return "\(fieldName) list cannot be empty"
            }
        }
    }
}
