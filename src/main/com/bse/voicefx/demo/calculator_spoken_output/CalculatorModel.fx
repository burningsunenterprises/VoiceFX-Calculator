/*
 * VoiceFxCalculator-1.fx
 *
 * Derived from SimpleCalc3 application by Dean Iverson as published on the
 * JavaFXpert blog in 2008
 *
 * Large portions of code were Developed in 2008 by Dean Iverson
 * as (a rewrite of James L. Weaver's original example)
 * to demonstrate creating applications using JavaFX SDK 1.0
 */
/*
 * CalculatorModel.fx
 *
 * Created on Dec 30, 2008, 5:56:49 PM
 */

package com.bse.voicefx.demo.calculator_spoken_output;

import com.bse.voicefx.demo.calculator_spoken_output.CalculatorModel.KeyModel;
import com.bse.voicefx.SpeechRecognizer;
import com.bse.voicefx.SpeechSynthesizer;
import java.lang.Double;
import javafx.lang.FX;

/**
 * @author dean
 */
public class KeyModel {
    public-init var character: String;
    public-init var description: String;
    public-init var action: function():Void;
    public function invoke_action() {
        action
    }
}

public class CalculatorModel {
    public-init var speechSynthesizer: SpeechSynthesizer;
    public-init var speechRecognizer: SpeechRecognizer;

    public-init var displayLength = 9;
    public-read var display = "0" on replace {
        if( display.length() >= displayLength ) {
            display = display.substring(0, displayLength);
        }
    }

    public-read var keys = [
        createCharacterKey( "0", ["zero","zed"] ),
        createCharacterKey( "1", ["one", "wuh"] ),
        createCharacterKey( "2", ["two"] ),
        createCharacterKey( "3", ["three"] ),
        createCharacterKey( "4", ["four", "fo"] ),
        createCharacterKey( "5", ["five"] ),
        createCharacterKey( "6", ["six", "sick"] ),
        createCharacterKey( "7", ["seven","sevum"] ),
        createCharacterKey( "8", ["eight"] ),
        createCharacterKey( "9", ["nine"] ),
        createOperatorKey( "+", ["plus","add"], add ),
        createOperatorKey( "-", ["minus","less","subtract","sub"], subtract ),
        createOperatorKey( "x", ["times","multiply","mult"], multiply ),
        createOperatorKey( "\u00f7", ["divide","divide by","divided","divided by"], divide ),
        createCharacterKey( ".", ["point","decimal"] ),
        createResultOperatorKey("=",["equals","equal","is"], equals, true),
        createImmediateOperatorKey("C", ["clear","erase"], clear, true),
        createImmediateOperatorKey("\u2190", ["backup","delete"], backup, false),
        createSpecialOperatorKey("\u266a", ["speak","tell me"], speak, false),
        createImmediateOperatorKey("Off", ["off","close"], off, false)
    ];

    var register = 0.0;
    var operation = add;
    var clearDisplayOnNextCharacter = true;

    package function appendToDisplay( character: String ) {
        if( character.matches( "[0-9\\.]" ) )
           display = "{display}{character}";
    }

    function createCharacterKey( character: String, description: String[] ) {
          var km = KeyModel {
            character: character
            description: description[0]
            action: function() {
                if (clearDisplayOnNextCharacter) {
                    display = "";
                    clearDisplayOnNextCharacter = false;
                }
                appendToDisplay( character );
                speechSynthesizer.speak( description[0] );
            }
        }
        speechRecognizer.recognize_me( km, "invoke-action", description);
        return km;
    }

    function createOperatorKey( character:String, description:String[], nextOp:function() ) {
        var km = KeyModel {
            character: character
            description: description[0]
            action: function() {
                speechSynthesizer.speak(description[0]);
                performOp( nextOp );
            }
        }
        speechRecognizer.recognize_me( km, "invoke-action", description);
        return km;
    }

    function createImmediateOperatorKey( character:String, description:String[], nextOp:function(), clear:Boolean ) {
        var km = KeyModel {
            character: character
            description: description[0]
            action: function() {
                speechSynthesizer.speak(description[0]);
                performImmediateOp( nextOp, clear );
            }
        }
        speechRecognizer.recognize_me( km, "invoke-action", description);
        return km;
    }

    function createResultOperatorKey( character:String, description:String[], nextOp:function(), clear:Boolean ) {
        var km = KeyModel {
            character: character
            description: description[0]
            action: function() {
                speechSynthesizer.speak(description[0]);
                performImmediateOp( nextOp, clear );
                speak();
            }
        }
        speechRecognizer.recognize_me( km, "invoke-action", description);
        return km;
    }

    function createSpecialOperatorKey( character:String, description: String[], nextOp:function(), clear:Boolean ) {
        var km = KeyModel {
            character: character
            description: description[0]
            action: function() {
                speechSynthesizer.speak( display );
            }
        }
        speechRecognizer.recognize_me( km, "invoke-action", description);
        return km;
    }

    function performOp( nextOp: function() ) {
        operation();
        operation = nextOp;
        clearDisplayOnNextCharacter = true;
    }

    function performImmediateOp( nextOp: function(), clear: Boolean ) {
        clearDisplayOnNextCharacter = clear;
        nextOp();
    }

    function add(): Void {
        register = register + Double.parseDouble( display );
    }

    function subtract(): Void {
        register = register - Double.parseDouble( display );
    }

    function multiply(): Void {
        register = register * Double.parseDouble( display );
    }

    function divide(): Void {
        register = register / Double.parseDouble( display );
    }

    function equals(): Void {
        performOp(add);
        display = if (register == (register as Integer))
            "{register as Integer}"
        else
            "{register}";
        register = 0.0;
    }

    function clear(): Void {
        register = 0.0;
        display = "0";
    }

    function backup(): Void {
        display = display.substring(0, display.length() - 1);
        if (display.equalsIgnoreCase("") or display.length() < 1) {
            display = "0";
        }
        clearDisplayOnNextCharacter = display.equalsIgnoreCase("0");
    }

    function speak(): Void {
      if (display.startsWith("-")) {
        speechSynthesizer.speak("negative");
        speechSynthesizer.speak( display.substring(1));
      }
      else {
        speechSynthesizer.speak( display );
      }
    }

    function off(): Void {
        speechRecognizer.stop();
        speechSynthesizer.stop();
        FX.exit();
    }

}
