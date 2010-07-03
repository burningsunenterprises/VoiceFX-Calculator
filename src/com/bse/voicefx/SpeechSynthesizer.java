/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bse.voicefx;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.speech.AudioException;
import javax.speech.EngineException;
import javax.speech.EngineManager;
import javax.speech.EngineStateException;
import javax.speech.synthesis.Synthesizer;
import javax.speech.synthesis.SynthesizerMode;

/**
 * Synthesizer
 *
 * @author esmith
 *
 * Synthesizer provides JavaFX classes with a
 */
public class SpeechSynthesizer {
  private static Logger logger = Logger.getLogger(SpeechSynthesizer.class.getName());

  private Synthesizer synthesizer;

  public SpeechSynthesizer() {
    try {
      synthesizer = createSynthesizer();
      synthesizer.allocate();
      synthesizer.resume();
    }
    catch (Exception ex) {
      logger.log(Level.SEVERE, null, ex);
      synthesizer = null;
    }
  }

  public void speak(String msg) {
    try {
      if (null != synthesizer) {
        synthesizer.speak(msg, null);
      }
    } catch (EngineStateException ex) {
      logger.log(Level.SEVERE, null, ex);
    }
  }

  public void stop() {
    try {
      synthesizer.deallocate();
    } catch (AudioException ex) {
      logger.log(Level.SEVERE, null, ex);
    } catch (EngineException ex) {
      logger.log(Level.SEVERE, null, ex);
    } catch (EngineStateException ex) {
      logger.log(Level.SEVERE, null, ex);
    }
  }
  private Synthesizer createSynthesizer() throws Exception {
    Synthesizer s = (Synthesizer) EngineManager.createEngine(SynthesizerMode.DEFAULT);
    return s;
  }
}
