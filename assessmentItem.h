//
//  assessmentItem.h
//  EMSTimers
//;

//  Created by Nelson Capes on 2/2/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface assessmentItem : NSObject <NSCoding>
@property (nonatomic) NSDate *assessmentTime;
@property (nonatomic) NSString *sytolicBloodPressure;
@property (nonatomic) NSString *diastolicBloodPressure;
@property (nonatomic) NSString *pulse;
@property (nonatomic) NSString *respirations;
@property (nonatomic) NSString *spO2;
@property (nonatomic) NSString *chiefComplaint;
@property (nonatomic) NSString *clinicalImpression;
@property (nonatomic) NSString *medicalHistory;
@property (nonatomic) NSString *allergies;
@property (nonatomic) NSString *mechanismOfInjury;
@property (nonatomic) NSString *currentMedications;
@property (nonatomic) NSString *treatments;
@property (nonatomic) NSString *narrative;
@end
