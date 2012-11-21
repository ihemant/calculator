//
//  ScientificCalculatorViewController.m
//  ScientificCalculator
//
//  Created by GNDBL on 09/11/12.
//  Copyright (c) 2012 GNDBL. All rights reserved.
//

#import "ScientificCalculatorViewController.h"
#import "ScientificCalci.h"
#import <QuartzCore/QuartzCore.h> 
#import "Float.h"

@interface ScientificCalculatorViewController ()
@property BOOL userIsInTheMiddle;
@property BOOL operationPress;
@property BOOL equalToPress;
@property BOOL memoryPress;
@property (nonatomic,strong) ScientificCalci *brain;
@property BOOL isRadian;
@end


@implementation ScientificCalculatorViewController

@synthesize userIsInTheMiddle = _userIsInTheMiddle;
@synthesize operationPress = _operationPress;
@synthesize brain = _brain;
@synthesize isRadian = _isRadian;
@synthesize memoryPress=_memoryPress;
-(ScientificCalci *)brain
{
    if(!_brain){
        _brain = [[ScientificCalci alloc]init];
    }
    return _brain;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self.brain radian]){
     self.optionLabel.text = @" Rad ";
    }
    else{
     self.optionLabel.text = @" Deg ";
    }
 }
- (IBAction)backspacePressed {
    //If string is empty or nil
    if([self.display.text length] <=1){
        self.display.text = @"0";
        self.userIsInTheMiddle = NO;
        return;
    }else{
        self.display.text = [self.display.text substringToIndex:([self.display.text length]-1)];
    }
}
- (IBAction)clearPressed {
    [self reset];
    [self.brain emptyStack];
}

- (IBAction)oneOperationPressed:(UIButton *)sender {
   //check for operation is preess
    if(self.operationPress)
    {
        self.operationPress = NO;
        self.userIsInTheMiddle=NO;
    }
    
    //If equalto is pressed then clear stack ,clear display and clear small display
    if(self.equalToPress)
    {
       self.smallDisplay.text = @"";
        self.userIsInTheMiddle = NO;
        self.operationPress = NO;
        self.equalToPress =NO;
    }
    double result = 0;
    NSString *operation = [sender currentTitle];
    if([operation isEqualToString:@"π"] || [operation isEqualToString:@"ℯ"]){
        
    }else{
        [self.brain pushOperand:[NSNumber numberWithDouble:[[self.display.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]]];
    }
    result=  [self.brain check:operation];
    NSNumber *numberResult = [NSNumber numberWithFloat:result];
    
    //Format Number With NSNumberFormatter
    self.display.text = [NSString stringWithFormat:@"%@",[self stringFromNumberNoNegativeZero:numberResult]];

    self.userIsInTheMiddle=NO;
    self.operationPress=NO;
    self.equalToPress=NO;
}

- (IBAction)isRad {
    BOOL isRadian = [self.brain radian];
    if(isRadian){
        [self.brain setRadian:NO];
        self.radianButton.selected = NO;
        [self.radianButton setTitle:@"Rad" forState:UIControlStateNormal];
      
     if(self.memoryPress){
          self.optionLabel.text =[@" Deg " stringByAppendingString:@"M"];
     }
     else{
          self.optionLabel.text =@" Deg ";
      }
    }
    else{
      [self.brain setRadian:YES];
        self.radianButton.selected = YES;
        self.radianButton.highlighted = YES;
        
      [self.radianButton setTitle:@"Deg" forState:UIControlStateSelected];
      if(self.memoryPress){
          self.optionLabel.text =[@" Rad " stringByAppendingString:@"M"];
       }
       else{
            self.optionLabel.text =@" Rad ";
       }
    }
    //NSLog(@"I M RAIAN PRESS %d",[self.brain radian]);
}


- (IBAction)dotPressed {
    if(self.operationPress){
        self.operationPress = NO;
        [self clear];
    }
    //If equal to is pressed then clear stack ,clear display and clear small display
    if(self.equalToPress)
    {
        [self clear];
        self.operationPress = NO;
        self.equalToPress = NO;
        self.userIsInTheMiddle = YES;
    }
    if([self.display.text rangeOfString:@"."].location == NSNotFound)
    {
    if(self.userIsInTheMiddle)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else
    {
        self.display.text = @"0.";
        self.userIsInTheMiddle=YES;
    }
  }
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    //If my operation is press then clear large display label
    if(self.operationPress)
    {
        self.operationPress = NO;
        self.userIsInTheMiddle=NO;
    }
    
    //If equalto is pressed then clear stack ,clear display and clear small display
    if(self.equalToPress)
    {
        [self reset];
    }
    
    //If user is in the middle of typing tan append string
    if(self.userIsInTheMiddle)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else   //If not than delete 0 and display digit
    {
        if(![digit isEqualToString:@"0"]) //if first character is not 0 display character
        {
        self.display.text = digit;
        self.userIsInTheMiddle=YES;
        }
    }
  }
- (IBAction)memoryOperation:(UIButton *)sender {
    NSString *operation = [sender currentTitle];
    
    if([operation isEqualToString:@"MC"]){
        [self.brain setRegisterMemory:0];
        self.memoryPress = NO;
        if([self.brain radian]){
         self.optionLabel.text =@" Rad ";
        }
        else{
            self.optionLabel.text =@" Deg ";
            
        }
    }else if([operation isEqualToString:@"MS"]){
         [self.brain setRegisterMemory:[[self.display.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]];
        if(!self.memoryPress){
          self.optionLabel.text = [self.optionLabel.text stringByAppendingFormat:@"M"];
          self.memoryPress = YES;
        }
    }
    else if([operation isEqualToString:@"MR" ]){
        
        
        NSNumber *numberResult = [NSNumber numberWithDouble:[self.brain registerMemory]];
        
        self.display.text = [NSString stringWithFormat:@"%@",[self stringFromNumberNoNegativeZero:numberResult]];
        
    }
    self.userIsInTheMiddle = NO;
}
- (IBAction)inverseOperation:(UIButton *)sender {
        if(self.inverseButton.selected ==YES){
        self.inverseButton.selected = NO;
        
        [self.sin setTitle:@"sin" forState:UIControlStateNormal];
        [self.cos setTitle:@"cos" forState:UIControlStateNormal];
        [self.tan setTitle:@"tan" forState:UIControlStateNormal];
        [self.sinh setTitle:@"sinh" forState:UIControlStateNormal];
        [self.cosh setTitle:@"cosh" forState:UIControlStateNormal];
        [self.tanh setTitle:@"tanh" forState:UIControlStateNormal];
        
    }
    else
    {
        self.inverseButton.selected  = YES;
        [self.sin setTitle:@"sin⁻¹" forState:UIControlStateNormal];
        [self.cos setTitle:@"cos⁻¹" forState:UIControlStateNormal];
        [self.tan setTitle:@"tan⁻¹" forState:UIControlStateNormal];
        [self.sinh setTitle:@"sinh⁻¹" forState:UIControlStateNormal];
        [self.cosh setTitle:@"cosh⁻¹" forState:UIControlStateNormal];
        [self.tanh setTitle:@"tanh⁻¹" forState:UIControlStateNormal];
        
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)operationPressed:(UIButton *)sender {
    double result = 0;
    NSString *operation = [sender currentTitle];
   
    if(self.equalToPress )
    {
        self.equalToPress=NO;
        [self clear];
    }
    if(!self.operationPress){
        //append display and operation and shows it on small display
        self.smallDisplay.text = [self.smallDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:operation]];
        [self.brain pushOperand:[NSNumber numberWithDouble:[[self.display.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]]];
        result=  [self.brain check:operation];
        [self.brain pushOperand:operation];
    }
    else{
        //if operation is pressed again
        
        //[self.brain removeOperand]; //remove previous operation
        self.smallDisplay.text = [self.smallDisplay.text substringToIndex:([self.smallDisplay.text length]-1)] ;
        BOOL precedenceHigh = [self.brain checkPrecedence:operation];
        //if small display does not have single number or bracket apply Handle case of 8+2+ then * then displays (8+2)*
        if(precedenceHigh && (![self isNumeric:self.smallDisplay.text]) &&(![self.smallDisplay.text hasSuffix:@")"])){
        self.smallDisplay.text =[@"(" stringByAppendingString:[self.smallDisplay.text stringByAppendingString:@")"]]; //adding parenthesis
        }
        result=  [self.brain check:operation];
        [self.brain pushOperand:operation];
        self.smallDisplay.text = [self.smallDisplay.text stringByAppendingString:operation];
    }

   NSNumber *numberResult = [NSNumber numberWithDouble:result];
   self.display.text = [NSString stringWithFormat:@"%@",[self stringFromNumberNoNegativeZero:numberResult]];
    
    self.equalToPress =NO;
    self.operationPress = YES;
    self.userIsInTheMiddle = NO;
}
- (IBAction)equalToPressed {
    double result = 0;
    if(!self.equalToPress){
    NSLog(@"Equal to operation press %d",[self operationPress]);
    self.smallDisplay.text = [self.smallDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@"="]];
    [self.brain pushOperand:[NSNumber numberWithDouble:[[self.display.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]]];
    result = [self.brain check:@"="];
    NSNumber *numberResult = [NSNumber numberWithDouble:result];
        
    self.display.text = [NSString stringWithFormat:@"%@",[self stringFromNumberNoNegativeZero:numberResult]];
    [self.brain emptyStack];
    }
    self.operationPress = NO;
    self.userIsInTheMiddle = NO;
    self.equalToPress =YES;
}

- (NSString *)stringFromNumberNoNegativeZero:(NSNumber *)number {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:15];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNotANumberSymbol:@"Not A Number"];
   
    NSString *s;
    
    NSLog(@" LENGTH=%d   AND  STRING = %@",[[number stringValue] length],[number stringValue]);
    
    if([[formatter stringFromNumber:number] length]>=15){
        [formatter setNumberStyle:kCFNumberFormatterScientificStyle];
        s = [[formatter stringFromNumber:number] autorelease];
    }
    else{
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        s = [[formatter stringFromNumber:number] autorelease];
    }
    [formatter release];
    
    if ([s isEqualToString:@"-0"]) return @"0";
    return s;
}

-(BOOL)isNumeric:(NSString *)s{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] ){
        return [sc isAtEnd];
    }
    return NO;
}

-(void)clear{
    self.smallDisplay.text=@"";
}

-(void)reset{
    self.display.text = @"0";
    self.smallDisplay.text = @"";
    self.userIsInTheMiddle = NO;
    self.operationPress = NO;
    self.equalToPress =NO;
}

- (void)dealloc {
    [_display release];
    [_smallDisplay release];
    [_radianButton release];
    [_optionLabel release];
    [_inverseButton release];
    [_sin release];
    [_cos release];
    [_tan release];
    [_tanh release];
    [_cosh release];
    [_sinh release];
    [_brain release];
 
    [super dealloc];
}
@end
