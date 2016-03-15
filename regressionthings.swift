//
//  regressionthings.swift
//  Bite Me
//
//  Created by Rafi Rizwan on 3/14/16.
//  Copyright © 2016 vi66r. All rights reserved.
//

import Foundation
import Darwin
import Parse

class regressionthings: NSObject {
    
    // (a * rating)*e^(-b*dist)
    // a = sum(d_i*g_i)
    // g_i = 0 or 1 given diet restriction
    // d_i = ...
    
    func processForRestaurant(restaurant: biteRestaurant, user: PFUser) -> Float{
        var score: Float = Float(0)
        
        //        score = (user["preferences"] as! NSDictionary).valueForKey(restaurant.categories)
        
        print("Algorithm Process For \(restaurant.name!) --------------")
        
        var randomPersonalBit = 2*drand48()
        randomPersonalBit = 1
        print("Random personal rating: \(randomPersonalBit)")
        let rating = Float(randomPersonalBit) * restaurant.rating!
        print("restaurant rating: \(rating)")
        print("distance: \(restaurant.distance!) metres away")
        //        var power = pow(M_E, Double((-1/200) * restaurant.distance!))
        
        //reassigning power to hold value of the triple logistic function below -- lol australia
        let power = triple_logistics(Double(restaurant.distance!), max: 3.0, plat1: 2.0, plat2: 1.0, min: 0.0, shift1: 160, shift2: 360, shift3: 500, steep1: 0.05, steep2: 0.05, steep3: 0.05)
        print("exponential bit: \(power)")
        score = Float(Double(rating) * power)
        print("final score: \(score)")
        print("----------------------------------------------")
        
        
        return score
    }
    
    
    func triple_logistics(x_i: Double, /*x: [Double],*/ max: Double, plat1: Double, plat2: Double, min: Double, shift1: Double, shift2: Double, shift3: Double, steep1: Double, steep2: Double, steep3: Double) -> Double{
        //this does something important
        //we're not really sure
        // but we think it correlates and ranks preference to distance
        // it looks like Uluru.
        
        //input parameters:
        // x = distance
        // max, plat 1, plat2, min == y values of maximum, two plateaus, and minimum
        // shifts == x values of the drops (where the function drops corresponding to distance, x)
        // steep1, 2, 3 == steepness of the drops (duh-doi)
        
        var m: Double, min1: Double, min2: Double, min3: Double, max1: Double, max2: Double, max3: Double
        if min > 0{
            m = pow(min, 2/3)
            min1 = m
            min2 = m
            min3 = m
            
            max3 = (plat2 - min)/m
            max2 = plat1/(m*(max3+m))-m
            max1 = max/((max2+m)*(max3+m))-m
        } else {
            m = 0
            min1 = 1
            min2 = 1
            min3 = 0
            
            max3 = plat2
            max2 = plat1/max3 - 1
            max1 = max/((max2+1)*(max3)) - min1
        }
        
        
        var y: Double = 0
        y = ((max1/(1 + pow(M_E, (steep1*(x_i-shift1)))) + min1) * (max2/(1 + pow(M_E, (steep2*(x_i-shift2)))) + min2) * (max3/(1 + pow(M_E, (steep3*(x_i-shift3)))) + min3))
        
        return y
        
    }
}
