//
//  ExtendMethod.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/27.
//  Copyright © 2016年 p. All rights reserved.
//

#import "ExtendMethod.h"

/*the greatest common divisor*/
long long gcd (long long p, long long q)
{
    if  (q == 0) return p;
    long long r = p % q;
    return gcd(q, r);
}

/*the lowest common multiple*/
long long lcm(long long x,long long y) {
    //get smaller one
    if  (x>y) {
        long long temp=x;
        x=y;
        y=temp;
    }//end if
    
    long long result=1;
    for(long long i=2;i<=x;i++) {
        
        while( (x%i==0) && (y%i==0) ) {
            result*=i;
            x=x/i;
            y=y/i;
        }//end if
    }//end for
    
    return result*(x*y);
}

unsigned long long gcdForUnsignedLongLong(unsigned long long t1,unsigned long long t2) {
    
    // Implement Euclid's algorithm
    if  (t2 > t1) {
        unsigned long long oldT2 = t2;
        t2 = t1;
        t1 = oldT2;
    }
    if  (t2 == 0) {
        return t1;
    }
    else{
        unsigned long long newTerm = (t1 % t2);
        return   gcdForUnsignedLongLong(t2,newTerm);
    }
}

unsigned long long lcmForUnsignedLongLong(unsigned long long t1 ,unsigned long long t2) {
    
    return t1 * t2 / gcdForUnsignedLongLong(t1, t2);
}


