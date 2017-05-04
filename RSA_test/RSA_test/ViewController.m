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
    [rsa encryptString:@"string" withPublicKey:@"key"];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
