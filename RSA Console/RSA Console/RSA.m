//
//  RSA.m
//  RSA Console
//
//  Created by Yongyang Nie on 5/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "RSA.h"

@interface RSA ()

@property (strong, nonatomic) NSArray *primes;
@property (strong, nonatomic) NSArray *smallPrimes;

@end

@implementation RSA

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"primes" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        self.primes = [string componentsSeparatedByString:@"\n"];
        
        self.smallPrimes = [NSArray arrayWithObjects:@2, @3, @5, @7, @11, @13, @17, @19, @23, @29, @31, @37, @41, @43, @47, @53, @59, @61, @67, @71, @73, @79, @83, @89, @97, @101, nil];
    }
    return self;
}

#pragma mark - Encrypt/Decrypt string

-(NSString *)encrypt:(NSString *)string withPublicKey:(NSString *)key{
    
    BigInteger *p = [self randomPrime];
    BigInteger *q = [self randomPrime];
    BigInteger *n = [p multiply:q];
    BigInteger *phiN = [[p subtract:[[BigInteger alloc] initWithString:@"1"]] multiply:[q subtract:[[BigInteger alloc] initWithString:@"1"]]];
    return nil;
}

-(NSString *)decrypt:(NSString *)string withPrivateKey:(NSString *)key{
    return nil;
}

#pragma mark - Encrypt/Decrypt data

-(NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)key{
    return nil;
}
-(NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)key{
    return nil;
}

#pragma mark - Private

-(BigInteger *)generateE:(BigInteger *)phiN{
    return nil;
}

-(int)GCD:(int) x and: (int)y{
    
    //the greatest common divisor of y and the remainder of x divided by y.
    if (x % y == 0) {
        return y;
    }else{
        return [self GCD:y and:x % y];
    }
}


-(BigInteger *)randomPrime{
    
    int index = arc4random()%self.primes.count-1;
    unsigned long value = [[self.primes objectAtIndex:index] unsignedLongValue];
    BigInteger *bi = [[BigInteger alloc] initWithUnsignedLong:value];
    return bi;
}

@end
