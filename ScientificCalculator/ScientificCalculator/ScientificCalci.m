//
//  ScientificCalci.m
//  ScientificCalculator
//
//  Created by GNDBL on 09/11/12.
//  Copyright (c) 2012 GNDBL. All rights reserved.
//

#import "ScientificCalci.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ScientificCalci()
@property (retain,nonatomic) NSMutableArray *operandStack;
@property (retain,nonatomic) NSDictionary *precedence;
@end



@implementation ScientificCalci
@synthesize operandStack = _operandStack;
@synthesize precedence=_precedence;
@synthesize radian= _radian;
@synthesize registerMemory = _registerMemory;
-(NSDictionary *)precedence
{   //SET PRECEDENCE OF OPERATORS IN DICTIONARY BY LAZY INSTANTIATION
    if(_precedence==nil){
      
      _precedence = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"1", @"+", @"2", @"*",@"1", @"-", @"2", @"/", @"0",@"=",@"3",@"mod",@"4",@"xʸ", nil];
        NSLog(@"DICTIONARY %@", _precedence);
    
    }
    return _precedence;
}

-(NSMutableArray *)operandStack
{
    if(_operandStack==nil)
     _operandStack = [[NSMutableArray alloc]init];
     return _operandStack;
}

- (void)removeOperand
{
    id topOfStack = [self.operandStack lastObject];
    //NSLog(@"THIS OBJECT IS REMOVED %@",topOfStack);
    if (topOfStack) [self.operandStack removeLastObject];
}

- (void)emptyStack
{
    [self.operandStack removeAllObjects];
}

-(void)pushOperand:(id)operand{
    [self.operandStack addObject:operand];
    //NSLog(@"STACK _____%@",self.operandStack);
}

-(BOOL)checkPrecedence:(NSString *)operation{
    BOOL precedence = NO;
    id operationChk = [self.operandStack lastObject];
    
    if(operationChk && [operationChk isKindOfClass:[NSString class]]){
    precedence =  ([[self.precedence objectForKey:operation] integerValue] > [[self.precedence objectForKey:operationChk] integerValue]);
    [self.operandStack removeLastObject];
    }
    
    //NSLog(@"PRECEDENCE IS %d",precedence);
    return precedence;
}


-(double)check:(NSString *)operation{
    /* IT CHEKS FIRST FOR SINGLE OPERATION IF YES THEN PERFORM OPERATION AND RETURN RESTULT IF ITS DOUBLE OPERAND OPERATION 
       THEN CHECK FOR ITS PRECEDENCE BY LOOKING IN DICTIONARY IF ITS PRECEDENCE IS SMALLER OR EQUAL TO PREVIOUS OPERATION IN
       STACK THEN PERFORM OPERATION IF NOT THEN PUSH OPERATION IN STACK(REVERSE POLISH NOTATION).
    */
    
    double result = [[self.operandStack lastObject] doubleValue];
    NSLog(@"Check to STack %@",self.operandStack);
    
    if ([operation isEqual:@"√"]) {
		result = [[self popOperand]doubleValue ];
        result = sqrt(result);
	}
    else if ([operation isEqual:@"3√"]) {
		result = [[self popOperand]doubleValue ];
        result = cbrt(result);
	}
	else if ([@"±" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
        if (result != 0) {
			result = -result;
		}
	}
	else if ([@"1/x" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
     	result = 1/result;
	}
    else if ([@"n!" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
     	result = [self factorial:result];
	}
	
	else if ([@"x²" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = pow(result , 2);
	}
	else if ([@"x³" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = pow(result , 3);
	}
    else if ([@"sin" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = sin(result);
		}else {//Degree
			result = sin(result * M_PI / 180);
		}
	}
	else if ([@"cos" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = cos(result);
		}else {//Degree
			result = cos(result * M_PI / 180);
		}
	}
	else if ([@"tan" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = tan(result);
		}else {//Degree
			result = tan(result * M_PI / 180);
		}
	}
    else if ([@"sinh" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = sinh(result);
    }
	else if ([@"cosh" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = cosh(result);
	}
	else if ([@"tanh" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = tanh(result);
	}
    else if ([@"sin⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = asin(result);
		}else {//Degree
			result = RADIANS_TO_DEGREES(asin(result));
		}
	}
	else if ([@"cos⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = acos(result);
		}else {//Degree
			result = RADIANS_TO_DEGREES(acos(result));
		}
	}
	else if ([@"tan⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		if (self.radian){
			result = atan(result);
		}else {//Degree
			result = RADIANS_TO_DEGREES(atan(result));
		}
	}
    else if ([@"sinh⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = asinh(result);
	}
	else if ([@"cosh⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = acosh(result);
	}
	else if ([@"tanh⁻¹" isEqual:operation]) {
        result = [[self popOperand]doubleValue ];
		result = atanh(result);
	}
    else if([@"π" isEqual:operation]){
        NSLog(@"%g",M_PI);
        result = M_PI;
    }
    else if([@"ℯ" isEqual:operation]){
        NSLog(@"%g",M_E);
        result = M_E;
    }

    else if([@"log₂" isEqual:operation]){
        result = [[self popOperand]doubleValue ];
        result =log2(result);
    }
    else if([@"log₁₀" isEqual:operation]){
        result = [[self popOperand]doubleValue ];
        result =log10(result);
    }
    else{
        if([self.operandStack count]>=3){
           NSString *operationCheck = [self.operandStack objectAtIndex:([self.operandStack count]-2)];
           while([[self.precedence objectForKey:operation] integerValue] <= [[self.precedence objectForKey:operationCheck] integerValue])
           {
               result = [self performOperation];
               if([self.operandStack count]>=3){
                  operationCheck = [self.operandStack objectAtIndex:([self.operandStack count]-2)];
               }
               else{
                   break;
               }
           }
        }
    }
    return result;
}


-(double)performOperation{
    double result = 0;
    //NSLog(@"perform OPERAUYUDI ________________ %@",self.operandStack);
    NSNumber *rightOperand = [self popOperand];
    [rightOperand retain];
    NSString *operation =  [self popOperand];
    [operation retain];
    NSNumber *leftOperand =  [self popOperand];
    [leftOperand retain];
    
    if([leftOperand isKindOfClass:[NSNumber class]] && [operation isKindOfClass: [NSString class] ]  &&
       [rightOperand isKindOfClass:[NSNumber class]]){
        if([operation isEqualToString:@"+"]){
            result = [leftOperand doubleValue] + [rightOperand doubleValue];
        }else if([operation isEqualToString:@"*"]){
            result = [leftOperand doubleValue] * [rightOperand doubleValue];
        }else if([operation isEqualToString:@"-"]){
            result = [leftOperand doubleValue] - [rightOperand doubleValue];
        }
        else if([operation isEqualToString:@"xʸ"]){
            result = pow([leftOperand doubleValue] , [rightOperand doubleValue]);
        }
        else if([operation isEqualToString:@"mod"]){
            
            result = fmod([leftOperand doubleValue] , [rightOperand doubleValue ]);
        }
        
        else if([operation isEqualToString:@"/"]){
            result = [leftOperand doubleValue] / [rightOperand doubleValue ];
        }
        
       [self pushOperand:[NSNumber numberWithDouble:result]];
    }
    [leftOperand release];
    [rightOperand release];
    [operation release];
    NSLog(@"RESULT IS %f",result);
    return  result;
}

-(double)factorial:(int)f
{
    if(f<0){
        return NAN;  //NOT A NUMBER
    }
    if( f == 0 )
        return 1;
    return f *[self factorial:(f - 1)] ;
    
}
-(id)popOperand{
    id obj = nil;
    if ([self.operandStack count] > 0)
    {
        obj = [[[self.operandStack lastObject] retain] autorelease];
        [self.operandStack removeLastObject];
    }
    return obj;
}

- (void)dealloc {
    [_operandStack release];
    [_precedence release];
    [super dealloc];
}


@end
