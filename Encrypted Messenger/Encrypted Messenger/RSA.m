//
//  RSA.m
//  RSA Console
//
//  Created by Yongyang Nie on 5/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "RSA.h"

@interface RSA ()

@end

@implementation RSA

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    if (self) {

        
    }
    return self;
}

#pragma mark - Encrypt/Decrypt string

+(NSDictionary *)prepareForEncryption{
    
    BigInteger *p = [RSA randomPrime];
    BigInteger *q = [RSA randomPrime];
    BigInteger *n = [p multiply:q];
    BigInteger *phiN = [[p subtract:[[BigInteger alloc] initWithString:@"1"]] multiply:[q subtract:[[BigInteger alloc] initWithString:@"1"]]];
    BigInteger *e = [RSA findeWithPhi:phiN];;
    long long d = [RSA modInverse:[e.stringValue longLongValue] m:[phiN.stringValue longLongValue]];
    BigInteger *privateKey = [[BigInteger alloc] initWithString:[NSString stringWithFormat:@"%lli", d]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:p.stringValue forKey:@"p"];
    [ud setObject:q.stringValue forKey:@"q"];
    [ud setObject:n.stringValue forKey:@"n"];
    [ud setObject:phiN.stringValue forKey:@"phiN"];
    [ud setObject:privateKey.stringValue forKey:@"key"];
    [ud synchronize];
    
    return @{@"n": n.stringValue,
             @"e": e.stringValue};
    
}

-(NSMutableArray <NSString *> *)encryptString:(NSString *)string withPublicKey:(NSString *)key n:(NSString *)nn{
    
    BigInteger *e = [[BigInteger alloc] initWithString:key];
    BigInteger *n = [[BigInteger alloc] initWithString:nn];
    
    //m * e mod n
    NSMutableArray *nums = [self intRepresentation:string];
    NSMutableArray *content = [NSMutableArray array];
    for (NSNumber *num in nums) {
        BigInteger *m = [[BigInteger alloc] initWithString:[num stringValue]];
        BigInteger *val = [m pow:e andMod:n];
        [content addObject:val.stringValue];
    }
    return content;
}


-(NSString *)decryptString:(NSMutableArray *)strings withKey:(NSString *)key withN:(NSString *)nn{
    
    BigInteger *d = [[BigInteger alloc] initWithString:key];
    BigInteger *n = [[BigInteger alloc] initWithString:nn];

    NSMutableArray *nums = [NSMutableArray array];
    for (NSString *string in strings) {
        BigInteger *c = [[BigInteger alloc] initWithString:string];
        BigInteger *m = [c pow:d andMod:n];
        [nums addObject:[NSNumber numberWithLongLong:[m.stringValue longLongValue]]];
    }
    return [self stringRepresentation:nums];
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
    for (int i = 0; i < string.length; i+=4) {
        NSData *m;
        if (i + 4 > string.length)
            m = [[string substringWithRange:NSMakeRange(i, string.length - i)] dataUsingEncoding:NSUTF8StringEncoding];
        else
            m = [[string substringWithRange:NSMakeRange(i, 4)] dataUsingEncoding:NSUTF8StringEncoding];
        
        int bn = 0;
        [m getBytes:&bn length:sizeof(bn)];
        [ints addObject:[NSNumber numberWithInt:bn]];
    }
    return ints;
}

/*-(NSMutableArray<NSNumber *> *)intRepresentation:(NSString *)string{
    
    NSMutableArray *ints = [NSMutableArray array];
    
    for (int i = 0; i < string.length; i+=4) {
        int sum = 0;
        for (int x = i; x <= i+4; x++) {
            int n = [self charToInt:[NSString stringWithFormat:@"%c", [string characterAtIndex:x]]];
            n = n * (8-x-i * 10);
            sum = sum + n;
        }
        if (i==0) {
            
        }
        [ints addObject:[NSNumber numberWithInt:sum]];
    }
    return ints;
}*/


-(NSString *)stringRepresentation:(NSMutableArray<NSNumber *> *)nums{

    NSString *str = @"";
    for (NSString *n in nums) {
        long long i = n.longLongValue;
        NSData *d = [NSData dataWithBytes:&i length:sizeof(i)];
        if ([NSString stringWithUTF8String:d.bytes] == nil) {
            str = [str stringByAppendingString:@" "];
        }else{
            str = [str stringByAppendingString:[NSString stringWithUTF8String:d.bytes]];
        }
    }
    return str;
}

-(int)charToInt:(NSString *)chr{
    NSArray *chrs = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z ! @ # $ % ^ & * ( ) _ + { } | : \" < > ? 1 2 3 4 5 6 7 8 9 0" componentsSeparatedByString:@" "];
    return (int)[chrs indexOfObject:chr];
}

#pragma mark - Private
//http://www.geeksforgeeks.org/multiplicative-inverse-under-modulo-m/
+(long long) modInverse:(long long)a m:(long long)m{
    
    long m0 = m, t, q;
    long x0 = 0, x1 = 1;

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

+(BigInteger *)findeWithPhi:(BigInteger *)phi{
    
    NSArray *smallPrimes = [NSArray arrayWithObjects:@2, @3, @5, @7, @11, @13, @17, @19, @23, @29, @31, @37, nil]; // @41, @43, @47, @53, @59, @61, @67, @71, @73, @79, @83, @89, @97, @101
    BigInteger *gcd = [[BigInteger alloc] initWithString:@"0"];
    int index = (int)smallPrimes.count - 1;
    while (![gcd.stringValue isEqualToString:@"1"]) {
        gcd = [phi gcd:[[BigInteger alloc] initWithString:[(NSNumber *)smallPrimes[index] stringValue]]];
        index--;
    }
    return [[BigInteger alloc] initWithString:[(NSNumber *)smallPrimes[index] stringValue]];
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

+(BigInteger *)randomPrime{
    
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"primes" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *primes = [string componentsSeparatedByString:@"\n"];

    int index = arc4random()%primes.count-1;
    NSString *value = [primes objectAtIndex:index];
    BigInteger *bi = [[BigInteger alloc] initWithString:value];
    return bi;
}

@end
