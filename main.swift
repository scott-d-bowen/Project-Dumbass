//  main.swift
//  Project Dumbass
//  Created by Scott D. Bowen on 18-Apr-2022.

import Foundation
import BigInt

let MASTER_LOOP_COUNT = 8192
let LOOP_COUNT = 1024
let PRODAT_LEN = 8
let FACTORIAL8 = 40320

var victoryCount: UInt64 = 0
var bytesSaved  : UInt64 = 0

print("Hello, World!")
let date_start = Date()

func createProdat() -> Data {
    let tridat: [UInt8] = [UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF),
                           UInt8.random(in: 0x00...0xFF)]
    
    let sorted: [UInt8] = tridat.sorted() //.reversed()

    // print(tridat, sorted)

    var prodat: [UInt8] = Array(repeating: 0, count: tridat.count)
    
    for iter in stride(from: tridat.count - 1, through: 1, by: -1) {
        prodat[iter] = sorted[iter] - sorted[iter - 1]
    }
    
    // print(prodat)
    return(Data(prodat))
}


for _ in 1...MASTER_LOOP_COUNT {
    var prodatData: Data = Data()

    for _ in 0..<LOOP_COUNT {
        prodatData.append(createProdat() )
    }

    let compProdatData = try NSData(data: prodatData).compressed(using: .lzma)
    // OFF: print(compProdatData, compProdatData.length)

    // OFF: print(PRODAT_LEN * LOOP_COUNT - compProdatData.length)

    let bigNum: BigUInt = BigUInt(FACTORIAL8).power(LOOP_COUNT)
    // OFF: print(bigNum.bitWidth, bigNum.serialize().count)

    let victory: Bool = compProdatData.length + bigNum.serialize().count < PRODAT_LEN * LOOP_COUNT
    print("Victory:", victory)
    let missedIt = PRODAT_LEN * LOOP_COUNT - compProdatData.length - bigNum.serialize().count
    print("Missed it by that much:", missedIt)
    
    if (victory) {
        victoryCount += 1
        bytesSaved   += UInt64(missedIt)
    }
}

print("victoryCount", victoryCount, "of", MASTER_LOOP_COUNT)
print("Maximum Bytes Saved:", bytesSaved)

print(-date_start.timeIntervalSinceNow, "seconds elapsed.")
print("Good Day.")
