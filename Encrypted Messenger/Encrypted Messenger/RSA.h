//
//  RSA.h
//  RSA Console
//
//  Created by Yongyang Nie on 5/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"

@interface RSA : NSObject

//stores and returns public keys
+(NSDictionary *)prepareForEncryption;

//encrypt with the other person's public key
-(NSMutableArray <NSString *> *)encryptString:(NSString *)string withPublicKey:(NSString *)key n:(NSString *)nn;

//decrypt with user's own private key
-(NSString *)decryptString:(NSMutableArray *)strings withKey:(NSString *)key withN:(NSString *)nn;

+(BigInteger *)randomPrime;

-(NSMutableArray <NSNumber *>*)intRepresentation:(NSString *)string;
-(NSString *)stringRepresentation:(NSMutableArray <NSNumber *>*)nums;

@end
