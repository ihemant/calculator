//
//  ScientificCalci.h
//  ScientificCalculator
//
//  Created by GNDBL on 09/11/12.
//  Copyright (c) 2012 GNDBL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScientificCalci : NSObject
-(void)pushOperand:(id)operand;
-(void)removeOperand;
-(double)check:(NSString *)operation;
-(void)emptyStack;
-(BOOL)checkPrecedence:(NSString *)operation;
@property BOOL radian;
@property double registerMemory;
@end
