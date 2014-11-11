//
// Created by Radoslaw Szeja on 11.11.14.
//

#import <Foundation/Foundation.h>
#import "RSZNotification.h"

@interface RSZNotification (RSZSpecAccessors)
- (void)associatedViewTapped:(UITapGestureRecognizer *)recognizer;
- (void)associatedViewSwiped:(UISwipeGestureRecognizer *)recognizer;
@end