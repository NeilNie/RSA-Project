//
//  BigInteger.h
//  BigInteger
//
//  Created by Jānis Kiršteins on 5/21/13.
//  Copyright (c) 2013 Jānis Kiršteins. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "tommath.h"

@interface BigInteger : NSObject <NSCoding>

- (id)initWithValue:(mp_int *)value;
- (mp_int *)value;

- (id)initWithUnsignedLong:(unsigned long)ul;
- (id)initWithString:(NSString *)string;
- (id)initWithString:(NSString *)string andRadix:(int)radix;
- (id)initWithCString:(char *)cString;
- (id)initWithCString:(char *)cString andRadix:(int)radix;

- (id)add:(BigInteger *)bigInteger;
- (id)subtract:(BigInteger *)bigInteger;
- (id)multiply:(BigInteger *)bigInteger;
- (id)divide:(BigInteger *)bigInteger;

- (id)remainder:(BigInteger *)bigInteger;
- (NSArray *)divideAndRemainder:(BigInteger *)bigInteger;

- (id)pow:(unsigned int)exponent;
- (id)pow:(BigInteger*)exponent andMod:(BigInteger*)modulus;
- (id)negate;
- (id)abs;

- (id)bitwiseXor:(BigInteger *)bigInteger;
- (id)bitwiseOr:(BigInteger *)bigInteger;
- (id)bitwiseAnd:(BigInteger *)bigInteger;
- (id)shiftLeft:(unsigned int)n;
- (id)shiftRight:(unsigned int)n;

- (id)gcd:(BigInteger *)bigInteger;

- (NSComparisonResult) compare:(BigInteger *)bigInteger;

- (unsigned long)unsignedIntValue;
- (NSString *)stringValue;
- (NSString *)stringValueWithRadix:(int)radix;

- (NSString *)description;

- (unsigned int)countBytes;
- (void)toByteArraySigned: (unsigned char*) byteArray;
- (void)toByteArrayUnsigned: (unsigned char*) byteArray;

@end
