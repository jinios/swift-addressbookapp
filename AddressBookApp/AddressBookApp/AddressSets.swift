//
//  AddressSets.swift
//  AddressBookApp
//
//  Created by YOUTH2 on 2018. 6. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class AddressSets {

    // MARK: static properties

    static let KOR_CODE_RANGE: CountableClosedRange<UInt32> = 0...18
    static let ENG_CODE_RANGE: CountableClosedRange<UInt32> = (AddressSets.ENG_START_CODE - AddressSets.CONVERTER)...(AddressSets.ENG_END_CODE - AddressSets.CONVERTER)
    static let ALL_CODE_RANGE: CountableClosedRange<UInt32> = 0...(AddressSets.ENG_END_CODE - AddressSets.CONVERTER + 1)
    static let CONVERTER: UInt32 = 46

    static let KOR_INITIAL_CONSONANT_CODES: [UInt32] = Array(KOR_CODE_RANGE)
    static let ALL_LETTERS = KOR_INITIAL_CONSONANT_LETTERS + ENG_INITIAL_CONSONANT_LETTERS
    static let KOR_INITIAL_CONSONANT_LETTERS = [
        "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    static let ENG_INITIAL_CONSONANT_LETTERS = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"
    ]

    static let ENG_START_CODE: UInt32 = 65
    static let ENG_END_CODE: UInt32 = 90

    private var addressListWithConsonant: [UInt32 : [AddressData]] = [:]
    private var addressList = [AddressData]()


    init(_ address: [AddressData]) {
        self.addressList = address.sorted()
    }

    // MARK: Check Consonant

    // 영어, 한글, 기타 문자인지 판단
    func checkConsonantOf(address: AddressData) -> UInt32 {
        let name = address.name
        // 영어일때
        if isEnglish(text: name) {
            guard let code = matchEng(text: name) else { return AddressSets.ALL_CODE_RANGE.last! }
            return code
        }
            // 한글일때
        else if isKorean(text: name) {
            guard let code = matchKor(text: name) else { return AddressSets.ALL_CODE_RANGE.last! }
            return code
        } else {
            // 특수문자의 경우 code range의 가장 마지막 숫자를 리턴
            return AddressSets.ALL_CODE_RANGE.last!
        }
    }

    func isEnglish(text: String) -> Bool {
        guard let first = text.uppercased().first else { return false }
        guard let scalarValue = UnicodeScalar(String(first))?.value else { return false }
        return AddressSets.ENG_START_CODE...AddressSets.ENG_END_CODE ~= scalarValue
    }

    func isKorean(text: String) -> Bool {
        guard let scalarValue = matchKor(text: text) else { return false }
        return AddressSets.KOR_CODE_RANGE ~= scalarValue
    }

    // 초성의 KOR INITIAL CONSONANT CODES 리턴
    func matchKor(text: String) -> UInt32? {
        guard let text = text.first else { return nil }
        let val = UnicodeScalar(String(text))?.value
        guard let value = val else { return nil }
        let firstConsonant = (value - 0xac00) / 28 / 21
        return firstConsonant
    }

    // 초성의 ENG INITIAL CONSONANT CODES 리턴
    func matchEng(text: String) -> UInt32? {
        guard let first = text.uppercased().first else { return nil }
        guard let scalarValue = UnicodeScalar(String(first))?.value else { return nil }
        let converted = scalarValue - 46
        return converted
    }

    func setAddressListWithConsonant() {
        addressListWithConsonant = addressList.reduce(into: [UInt32 : [AddressData]]()) {
            $0[checkConsonantOf(address: $1), default:[]].append($1)
        }
    }

}
