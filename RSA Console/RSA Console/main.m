//
//  main.m
//  RSA Console
//
//  Created by Yongyang Nie on 4/28/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInteger.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //int representation
        NSString *string = @"I am Neil. Hello World.  ";
        NSMutableArray *ints = [NSMutableArray array];
        for (int i = 0; i < string.length-4; i+=4) {
            NSData *m = [[string substringWithRange:NSMakeRange(i, 4)] dataUsingEncoding:NSUTF8StringEncoding];
            int bn = 0;
            [m getBytes:&bn length:sizeof(bn)];
            [ints addObject:[NSNumber numberWithInt:bn]];
        }
        NSLog(@"ints: %@", ints);
        
        //restore
        NSString *str = @"";
        for (NSNumber *n in ints) {
            int i = n.intValue;
            NSData *d = [NSData dataWithBytes:&i length:sizeof(i)];
            str = [str stringByAppendingString:[NSString stringWithUTF8String:d.bytes]];
            NSLog(@"%@", [NSString stringWithUTF8String:d.bytes]);
        }
        NSLog(@"str: %@", str);
    }
    return 0;
}
