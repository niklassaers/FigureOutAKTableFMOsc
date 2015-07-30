//
//  ViewController.swift
//  FigureOutAKTableFMOsc
//
//  Created by Niklas Saers on 28/07/15.
//  Copyright (c) 2015 SAERS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    internal var fmOscilator : WTFMOscillatorInstrument?
    internal var note : AKNote?

    @IBOutlet weak var waveFormSC: UISegmentedControl!
    @IBOutlet weak var amplitudeSC: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fmOscilator = WTFMOscillatorInstrument()
        AKOrchestra.addInstrument(fmOscilator!)
        
        let freq = Float(440.0)
        note = FMSynthesizerNote(frequency: freq)

        AKOrchestra.start()
        
    }
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        


        if waveFormSC.selectedSegmentIndex == 0 {
            let sine = AKTable.standardSineWave()
            sine.scaleBy(0.7)
            self.fmOscilator?.oscillator.waveform = sine
            
        } else if waveFormSC.selectedSegmentIndex == 1 {
            let square = AKTable.standardSquareWave()
            square.scaleBy(0.6)
            self.fmOscilator?.oscillator.waveform = square
            
        } else if waveFormSC.selectedSegmentIndex == 2 {
            let harmonic = self.harmonicWaveform()
            harmonic.scaleBy(0.7)
            self.fmOscilator?.oscillator.waveform = harmonic
            
        }
        
        if amplitudeSC.selectedSegmentIndex == 0 {
            self.fmOscilator!.oscillator.amplitude = akp(0.7)
            
        } else if amplitudeSC.selectedSegmentIndex == 0 {
            let adsr = AKLinearADSREnvelope(attackDuration: akp(0.1), decayDuration: akp(0.1), sustainLevel: akp(0.8), releaseDuration: akp(0.2), delay: akp(0.0))
            self.fmOscilator!.oscillator.amplitude = adsr
            
        }

        AKOrchestra.updateInstrument(self.fmOscilator!)        
        fmOscilator?.playNote(note!)
    }

    func akp(f:Float) -> AKConstant {
        return AKConstant(float: f)
    }
    
    
    func harmonicWaveform() -> AKTable {
        let fftGen = AKFourierSeriesTableGenerator()
        fftGen.addSinusoidWithPartialNumber(1, strength: 0.9)
        fftGen.addSinusoidWithPartialNumber(2, strength: 0.3)
        fftGen.addSinusoidWithPartialNumber(3, strength: 0.5)
        fftGen.addSinusoidWithPartialNumber(4, strength: 0.1)
        fftGen.addSinusoidWithPartialNumber(5, strength: 0.2)
        let table = AKTable()
        table.populateTableWithGenerator(fftGen)
        return table
    }

    @IBAction func stop(sender: AnyObject) {
        note!.stop()
        fmOscilator!.stop()
    }
}

