//
//  assessmentItem.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/2/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This class's encodeWithCoder method is called through the patientItem.m when the application enters background to archive an assessmentItem. It's initWithCoder method is called through the patientItem.m when the application becomes active to unarchive the assessmentItem.
#import "assessmentItem.h"

@implementation assessmentItem
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _assessmentTime = [aDecoder decodeObjectForKey:@"assessmentTime"];
        _sytolicBloodPressure = [aDecoder decodeObjectForKey:@"systolicBloodPressure"];
        _diastolicBloodPressure = [aDecoder decodeObjectForKey:@"diastolicBloodPressure"];
        _pulse = [aDecoder decodeObjectForKey:@"pulse"];
        _respirations = [aDecoder decodeObjectForKey:@"respirations"];
        _spO2 = [aDecoder decodeObjectForKey:@"spO2"];
        _chiefComplaint = [aDecoder decodeObjectForKey:@"chiefComplaint"];
        _clinicalImpression = [aDecoder decodeObjectForKey:@"clinicalImpression"];
        _medicalHistory = [aDecoder decodeObjectForKey:@"medicalHistory"];
        _allergies = [aDecoder decodeObjectForKey:@"allergies"];
        _mechanismOfInjury = [aDecoder decodeObjectForKey:@"mechanismOfInjury"];
        _currentMedications = [aDecoder decodeObjectForKey:@"currentMedications"];
        _treatments = [aDecoder decodeObjectForKey:@"treatments"];
        _narrative = [aDecoder decodeObjectForKey:@"narrative"];
        
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.assessmentTime forKey:@"assessmentTime"];
    [aCoder encodeObject:self.sytolicBloodPressure                  forKey:@"systolicBloodPressure"];
    [aCoder encodeObject:self.diastolicBloodPressure                                            forKey:@"diastolicBloodPressure"];
    [aCoder encodeObject:self.pulse forKey:@"pulse"];
    [aCoder encodeObject:self.respirations forKey:@"respirations"];
    [aCoder encodeObject:self.spO2 forKey:@"spO2"];
    [aCoder encodeObject:self.chiefComplaint forKey:@"chiefComplaint"];
    [aCoder encodeObject:self.clinicalImpression forKey:@"clinicalImpression"];
    [aCoder encodeObject:self.medicalHistory forKey:@"medicalHistory"];
     [aCoder encodeObject:self.allergies forKey:@"allergies"];
    [aCoder encodeObject:self.mechanismOfInjury forKey:@"mechanismOfInjury"];
    [aCoder encodeObject:self.currentMedications forKey:@"currentMedications"];
    [aCoder encodeObject:self.treatments forKey:@"treatments"];
    [aCoder encodeObject:self.narrative forKey:@"narrative"];
}
@end
