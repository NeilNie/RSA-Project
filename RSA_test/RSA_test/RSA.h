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

-(NSString *)encryptString:(NSString *)string withPublicKey:(NSString *)key;
-(NSString *)decryptString:(NSString *)string withPrivateKey:(NSString *)key;

-(NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)key;
-(NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)key;

-(BigInteger *)randomPrime;

-(NSMutableArray <NSNumber *>*)intRepresentation:(NSString *)string;
-(NSString *)stringRepresentation:(NSMutableArray <NSNumber *>*)nums;

@end
