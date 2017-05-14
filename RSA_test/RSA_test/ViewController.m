//
//  ViewController.m
//  RSA_test
//
//  Created by Yongyang Nie on 5/2/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RSA *rsa = [[RSA alloc] init];
    
    NSLog(@"%@", [RSA modInverse:[[BigInteger alloc] initWithString:@"3"] m:[[BigInteger alloc] initWithString:@"11"]]);
    NSLog(@"%@", [RSA modInverse:[[BigInteger alloc] initWithString:@"10"] m:[[BigInteger alloc] initWithString:@"17"]]);
    //[rsa ModInverse:3 m:11];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
