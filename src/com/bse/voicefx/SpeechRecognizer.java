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
import javax.speech.recognition.Recognizer;
import javax.speech.recognition.RecognizerMode;

/**
 *
 * @author esmith
 */
public class SpeechRecognizer {

    private static Logger logger = Logger.getLogger(SpeechRecognizer.class.getName());
    private Recognizer recognizer;
    private GrammarResolver resolver;

    public SpeechRecognizer(String grammarNamePrefix) {
        try {
            recognizer = createRecognizer();
            logger.log( Level.ALL, "Recognizer created()" );
            recognizer.allocate();
            recognizer.requestFocus();
            recognizer.resume();
            logger.log( Level.ALL, "Recognizer allocated()" );
            resolver = new GrammarResolver(recognizer, grammarNamePrefix);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, null, ex);
            recognizer = null;
        }
    }

    public void recognize_me(Object instance, String method, String[] tokens) {
        try {
            /*Logger.log(Level.ALL, */System.out.println("Pausing Recognizer...");
            recognizer.pause();
            /*Logger.log(Level.ALL, */System.out.println("Adding Grammar Rule...");
            resolver.addGrammarRule(instance, method, tokens);
            /*Logger.log(Level.ALL, */System.out.println("Recognition is established for " + tokens.toString());
        } catch (Exception e) {
            /*Logger.log(Level.ALL, */System.out.println("Recognition is not established for " + tokens.toString());
                    //" due to " + e.getLocalizedMessage(), e);
        } finally {
            /*Logger.log(Level.ALL, */System.out.println("Resuming Recognizer...");
            recognizer.resume();
            /*Logger.log(Level.ALL, */System.out.println("Recognizer Resumed");
        }
    }

    private Recognizer createRecognizer() throws Exception {
        /*Logger.log(Level.ALL, */System.out.println("Creating Recognizer");
        Recognizer r = (Recognizer) EngineManager.createEngine(RecognizerMode.DEFAULT);
        return r;
    }

    public void stop() {
        try {
            /*Logger.log(Level.ALL, */System.out.println("Stopping Recognizer.");
            recognizer.deallocate();
        } catch (AudioException ex) {
            Logger.getLogger(SpeechRecognizer.class.getName()).log(Level.SEVERE, null, ex);
        } catch (EngineException ex) {
            Logger.getLogger(SpeechRecognizer.class.getName()).log(Level.SEVERE, null, ex);
        } catch (EngineStateException ex) {
            Logger.getLogger(SpeechRecognizer.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
