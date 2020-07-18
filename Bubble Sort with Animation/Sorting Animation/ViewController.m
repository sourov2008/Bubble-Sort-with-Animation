//
//  ViewController.m
//  Sorting Animation
//
//  Created by Shourob Datta (Wipro Macbook) on 14/7/20.
//  Copyright © 2020 Shourob. All rights reserved.
//
//https://stackoverflow.com/questions/58111556/how-to-make-uianimation-execute-one-at-a-time-iterate-over-for-loop-instead-o/58112536#58112536
//https://stackoverflow.com/questions/17949511/the-proper-way-of-doing-chain-animations


/*
 
 HOW TO SOLVE PROBLEM
 
 - I used bubble sort for to solve the problem. The time complexity of Bubble sort is O(n^2). I used this because of bubble sort is efficient enough up to number range 10,000.
 - Iterate n-1 steps.
 - During iteration I saved the animation as a block into a queue.
 
 
 
 FOR TESTING
 
 - variable name "unsortedArray" in the view viewDidLoad refelect the number of elements.
 - "unsortedArray" count will be same as lblDigitArray count.
 Disclosure - * drag all label outlet sequnetially, other wise animation may disrupt.
 
 */

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *lblDigitArray;
@property (weak, nonatomic) IBOutlet UILabel *lblIteration;


@end

@implementation ViewController
NSMutableArray *numberArrayAsValueType;


- (void)viewDidLoad {
    
     [super viewDidLoad];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc]initWithObjects:@"4",@"-33",@"7",@"1",@"5",nil];
    numberArrayAsValueType = [unsortedArray mutableCopy];
    //[self bubbleSort:unsortedArray];
    [self setNumberLabelUI:unsortedArray];
    
    NSLog(@"%@ ",  [self bubbleSort:unsortedArray]);

 
}


-(void)setNumberLabelUI: (NSMutableArray *)unsortedArray{
    
    int index = 0;
    
    for (UILabel *label in self.lblDigitArray) {
      
        label.text = unsortedArray[index];
        label.layer.cornerRadius = 5;
        index ++;
    }
    
}


- (NSArray *)bubbleSort:(NSMutableArray *)sortedArray
{
    
            __block NSMutableArray* animationBlocks = [NSMutableArray new];
            typedef void(^animationBlock)(BOOL);
            
            // getNextAnimation
            // removes the first block in the queue and returns it
            animationBlock (^getNextAnimation)(void) = ^{
                
                if ([animationBlocks count] > 0){
                    animationBlock block = (animationBlock)[animationBlocks objectAtIndex:0];
                    [animationBlocks removeObjectAtIndex:0];
                    return block;
                } else {
                    return ^(BOOL finished){
                        animationBlocks = nil;
                    };
                }
            };


            int  index, subIndex, swap;
    
            for (index = 0 ; index < sortedArray.count - 1; index++)
            {
                for (subIndex = 0 ; subIndex < sortedArray.count - index - 1; subIndex++)
                {
                    NSLog( @" c = %d  d = %d", index,subIndex);
                    
                    //add a block to our queue
                    // pair animation
                    [animationBlocks addObject:^(BOOL finished){
                        
                        self.lblIteration.text = [NSString stringWithFormat:@"Iteration : %d", index+1];
                        
                        for (UILabel *label in self.lblDigitArray) {
                            // remove all previous assigned color
                            label.layer.backgroundColor = [UIColor whiteColor].CGColor;

                        }
                        
                        [UIView animateWithDuration:3.0 animations:^{
                            
                             UILabel *firstElement = self.lblDigitArray[subIndex];
                            firstElement.layer.backgroundColor = [UIColor whiteColor].CGColor;
                            firstElement.layer.backgroundColor = [UIColor redColor].CGColor;
                            
                             UILabel *secondElement = self.lblDigitArray[subIndex+1];
                            secondElement.layer.backgroundColor = [UIColor whiteColor].CGColor;
                            secondElement.layer.backgroundColor = [UIColor redColor].CGColor;
                            
                            sleep(1);
                            
                        } completion:getNextAnimation()];
                    }];
                    
                    
                    // swap
                    
                    if ([sortedArray[subIndex]intValue] > [sortedArray[subIndex+1]intValue]) /* For decreasing order use < */{

                        //add a block to our queue
                        // Swap animation
                        [animationBlocks addObject:^(BOOL finished){

                            // Swap animation
                            [UIView animateWithDuration:2 animations:^{

                                int swap;

                                    UILabel *firstElement = self.lblDigitArray[subIndex];
                                    UILabel *secondElement = self.lblDigitArray[subIndex+1];

                                    NSString *firstElementText = firstElement.text;
                                    NSString *secondElementText = secondElement.text;

                                    firstElement.text = secondElementText;
                                    secondElement.text = firstElementText;

                                        swap = [numberArrayAsValueType[subIndex]intValue];
                                        numberArrayAsValueType[subIndex]   = numberArrayAsValueType[subIndex+1];
                                        numberArrayAsValueType[subIndex+1] = [NSNumber numberWithInteger:swap];
                                sleep(1);

                            } completion:getNextAnimation()];

                         }];

                    }

                    
                    if ([sortedArray[subIndex]intValue] > [sortedArray[subIndex+1]intValue]) /* For decreasing order use < */
                    {
                        swap       = [sortedArray[subIndex]intValue];
                        sortedArray[subIndex]   = sortedArray[subIndex+1];
                        sortedArray[subIndex+1] = [NSNumber numberWithInteger:swap];
                    }
                    
                }
                                
            }getNextAnimation()(YES);
        

            // This block will call clear last background
            //add a block to our queue
             [animationBlocks addObject:^(BOOL finished){;
                 NSLog(@"Multi-step Animation Complete!");
                 for (UILabel *label in self.lblDigitArray) {
                     // remove all previous assigned color
                     label.layer.backgroundColor = [UIColor whiteColor].CGColor;

                 }
                self.lblIteration.text =  @"Sort completed";
 
             }];
    
  
       return sortedArray;
}


@end
