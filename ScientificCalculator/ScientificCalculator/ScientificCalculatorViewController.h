//
//  ScientificCalculatorViewController.h
//  ScientificCalculator
//
//  Created by GNDBL on 09/11/12.
//  Copyright (c) 2012 GNDBL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScientificCalculatorViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *display;
@property (retain, nonatomic) IBOutlet UILabel *smallDisplay;
@property (retain, nonatomic) IBOutlet UIButton *radianButton;
@property (retain, nonatomic) IBOutlet UILabel *optionLabel;
@property (retain, nonatomic) IBOutlet UIButton *inverseButton;
@property (retain, nonatomic) IBOutlet UIButton *sin;
@property (retain, nonatomic) IBOutlet UIButton *cos;
@property (retain, nonatomic) IBOutlet UIButton *tan;
@property (retain, nonatomic) IBOutlet UIButton *tanh;
@property (retain, nonatomic) IBOutlet UIButton *cosh;
@property (retain, nonatomic) IBOutlet UIButton *sinh;

@end
