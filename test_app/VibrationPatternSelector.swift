//
//  VibrationPatternSelector.swift
//  MultiVibeUserStudy
//
//  Created by John Pasquesi on 11/25/19.
//  Copyright © 2019 John Pasquesi. All rights reserved.
//

import Foundation

public class VibrationPatternSelector {
    var patternSet01 = ["A","B","C","D","E","AA","BBB", "CCCC", "DDDDD", "EE", "DDD", "AAAA", "BBBBB", "CC", "EEEEEE"];
    var patternSet02 = ["AB", "AC", "AD", "AE", "BC", "BD", "BE", "CD", "CE", "DE", "AAE", "BBCC", "DDEEE", "CCAAA", "BBD"];
    var patternSet03 = ["ABC", "ABD", "ABE", "ACD", "ACE", "ADE", "BCD", "BCE", "BDE", "CDE", "AACE", "BBCCD", "CDDA","BBBEC","EEBA"]
    var patternSet04 = ["ABCD","ABCE","ABDE","ACDE",
                        "BCDE","AABCD","ABCCE","ABBDE",
                        "ACDDE","BCDEE"]
    var patternSet05 = ["ABCDE"]
    var patternSets: [[String]]
    
    var numVibList = [1,2,3,4,5]
    var numVibCounts = [0,0,0,0,0]
    
    var numVibs = 1
    
    var calibrationSet = ["AA", "AB", "AC", "AD", "AE",
                          "BB", "BC", "BD", "BE",
                          "CC", "CD", "CE",
                          "DD", "DE",
                          "EE"]
    
    init(){
        patternSets = [patternSet01, patternSet02, patternSet03, patternSet04, patternSet05]
    }
    
    func reset(){
        numVibList = [1,2,3,4,5]
        numVibCounts = [0,0,0,0,0]
    }
    
    private func getNumVibs() -> Int{
        if numVibList.count == 0 {
            return 0
        }
        let numInd = Int.random(in: 0 ..< numVibList.count)
        numVibs = numVibList[numInd]
        numVibCounts[numInd] += 1
        if numVibCounts[numInd] >= 2 {
            numVibList.remove(at: numInd)
            numVibCounts.remove(at: numInd)
        }
        return numVibs
    }
    
    private func findPattern(numvibs: Int) -> [Character]{
        let vibPattern = patternSets[numvibs - 1].randomElement()!
        var strArr = Array(vibPattern)
        strArr.shuffle()
        return strArr
    }
    
    func getPattern() -> (Int, [Character], Int){
        let num = getNumVibs()
        if num == 0{
            return (num, ["Z","Z","Z","Z","Z"], 5)
        }
        let patt = findPattern(numvibs: num)
        return (num, patt, patt.count)
    }
    
    func getCalibrationPattern() -> [Character]{
        if calibrationSet.count <= 0{
            return ["Z","Z"]
        }
        let calPattern = calibrationSet.randomElement()!
        if let index = calibrationSet.firstIndex(of: calPattern) {
            calibrationSet.remove(at: index)
        }
        var calArr = Array(calPattern)
        calArr.shuffle()
        return calArr
    }
    

}
