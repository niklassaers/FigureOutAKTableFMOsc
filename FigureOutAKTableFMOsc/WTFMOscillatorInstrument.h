//
//  WTFMOscillatorInstrument.h
//  Well Tempered
//
//  Created by Niklas Saers on 11/05/15.
//  Copyright (c) 2015 SAERS. All rights reserved.
//

#import "AKFoundation.h"

/// A synth that uses FM Synthesis to generate sounds, with frequency and amplitude defined
@interface WTFMOscillatorInstrument : AKInstrument

// Instrument Properties
//@property AKInstrumentProperty *amplitude;
@property AKFMOscillator *oscillator;
@end

@interface WTFMOscillatorNote : AKNote

// Note properties
@property AKNoteProperty *frequency;
@property AKNoteProperty *amplitude;

- (instancetype)initWithFrequency:(float)frequency amplitude:(float)amplitude;

@end
