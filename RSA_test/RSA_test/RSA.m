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
@property (strong, nonatomic) BigInteger *privateKey;

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

-(NSString *)encryptString:(NSString *)string withPublicKey:(NSString *)key{
    
    BigInteger *p = [self randomPrime];
    BigInteger *q = [self randomPrime];

    BigInteger *n = [p multiply:q];
    BigInteger *phiN = [[p subtract:[[BigInteger alloc] initWithString:@"1"]] multiply:[q subtract:[[BigInteger alloc] initWithString:@"1"]]];
    BigInteger *e = [self findeWithPhi:phiN];
    int d = [self modInverse:[e.stringValue intValue] m:[phiN.stringValue intValue]];
    self.privateKey = [[BigInteger alloc] initWithString:[NSString stringWithFormat:@"%i", d]];
    
    //me mod n
    NSMutableArray *nums = [self intRepresentation:string];
    BigInteger *m = [[BigInteger alloc] initWithString:[(NSNumber *)[nums firstObject] stringValue]];
    BigInteger *val = [m pow:e andMod:n];
    NSLog(@"%@",val);
    return nil;
}

-(NSString *)decryptString:(NSString *)string withPrivateKey:(NSString *)key{
    return nil;
}

#pragma mark - Encrypt/Decrypt data

-(NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)key{
    return nil;
}
-(NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)key{
    return nil;
}

#pragma Int / String

-(NSMutableArray<NSNumber *> *)intRepresentation:(NSString *)string{
    
    NSMutableArray *ints = [NSMutableArray array];
    for (int i = 0; i < string.length-4; i+=4) {
        NSData *m = [[string substringWithRange:NSMakeRange(i, 4)] dataUsingEncoding:NSUTF8StringEncoding];
        int bn = 0;
        [m getBytes:&bn length:sizeof(bn)];
        [ints addObject:[NSNumber numberWithInt:bn]];
    }
    return ints;
}

-(NSString *)stringRepresentation:(NSMutableArray<NSNumber *> *)nums{

    NSString *str = @"";
    for (NSNumber *n in nums) {
        int i = n.intValue;
        NSData *d = [NSData dataWithBytes:&i length:sizeof(i)];
        str = [str stringByAppendingString:[NSString stringWithUTF8String:d.bytes]];
        NSLog(@"%@", [NSString stringWithUTF8String:d.bytes]);
    }
    return str;
}

#pragma mark - Private
//http://www.geeksforgeeks.org/multiplicative-inverse-under-modulo-m/
-(int) modInverse:(int)a m:(int)m{
    
    int m0 = m, t, q;
    int x0 = 0, x1 = 1;

    while (a > 1){
        // q is quotient
        q = a / m;
        t = m;
        
        // m is remainder now, process same as
        // Euclid's algo
        m = a % m, a = t;
        
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }
    
    // Make x1 positive
    if (x1 < 0)
        x1 += m0;
    
    return x1;
}

-(BigInteger *)findeWithPhi:(BigInteger *)phi{
    
    BigInteger *gcd = [[BigInteger alloc] initWithString:@"0"];
    int index = (int)self.smallPrimes.count - 1;
    while (![gcd.stringValue isEqualToString:@"1"]) {
        gcd = [phi gcd:[[BigInteger alloc] initWithString:[(NSNumber *)self.smallPrimes[index] stringValue]]];
        index--;
    }
    return [[BigInteger alloc] initWithString:[(NSNumber *)self.smallPrimes[index] stringValue]];
}

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
    NSString *value = [self.primes objectAtIndex:index];
    BigInteger *bi = [[BigInteger alloc] initWithString:value];
    return bi;
}

@end
