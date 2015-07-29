//
//  WTFMOscillatorInstrument.m
//  Well Tempered
//
//  Created by Niklas Saers on 11/05/15.
//  Copyright (c) 2015 SAERS. All rights reserved.
//

#import "WTFMOscillatorInstrument.h"

@implementation WTFMOscillatorInstrument {
    AKLinearADSREnvelope *_adsr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Note Properties
        WTFMOscillatorNote *note = [[WTFMOscillatorNote alloc] init];
        
        // Instrument Properties
//        _amplitude = [self createPropertyWithValue:0.5 minimum:0.0 maximum:1.0];
        
        _adsr = [[AKLinearADSREnvelope alloc] initWithAttackDuration:akp(0.1)
                                                       decayDuration:akp(0.1)
                                                        sustainLevel:akp(0.8)
                                                     releaseDuration:akp(0.2)
                                                               delay:akp(0)];
        
        // Instrument Definition
        self.oscillator = [AKFMOscillator oscillator];
        self.oscillator.modulationIndex = akp(1);
        self.oscillator.modulatingMultiplier = akp(0);
        self.oscillator.baseFrequency = note.frequency;
        self.oscillator.amplitude = [_adsr scaledBy:akp(1.0)];
        
        [self setAudioOutput:[self.oscillator scaledBy:akp(0.5)]];
    }
    return self;
}


@end

// -----------------------------------------------------------------------------
#  pragma mark - FMOscillatorInstrument Note
// -----------------------------------------------------------------------------


@implementation WTFMOscillatorNote

- (instancetype)init
{
    self = [super init];
    if (self) {
        _frequency = [self createPropertyWithValue:440 minimum:100 maximum:20000];
        _amplitude = [self createPropertyWithValue:1 minimum:0 maximum:1];
    }
    return self;
}

- (instancetype)initWithFrequency:(float)frequency amplitude:(float)amplitude;
{
    self = [self init];
    if (self) {
        _frequency.value = frequency;
        _amplitude.value = amplitude;
    }
    return self;
}

@end
