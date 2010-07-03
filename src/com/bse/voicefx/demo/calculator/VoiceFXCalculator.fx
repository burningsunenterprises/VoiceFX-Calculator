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
package com.bse.voicefx.demo.calculator;

import com.bse.voicefx.demo.calculator.CalculatorModel;
import com.bse.voicefx.demo.common.CalculatorDisplay;
import com.bse.voicefx.demo.common.CalculatorKey;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.Cell;
import org.jfxtras.scene.layout.Grid;
import org.jfxtras.scene.layout.Row;

/**
 * The "stage" for the application
 */
Stage {
    // The model
    def model = CalculatorModel {}
    def columns = 4
    def keyPositionMap = [
        16, 17, 18, 19
        7,  8,  9, 10,
        4,  5,  6, 11,
        1,  2,  3, 12,
        14,  0, 15, 13
    ]

    var theScene: Scene;

    title: "VoiceFXCalculator"
    scene:  theScene = Scene {
        width: 300
        height: 400
        fill: Color.BLACK
        stylesheets: "{__DIR__}VoiceFXCalculator.css"
        content: Grid {
            border: 10
            width: bind theScene.width
            height: bind theScene.height
            hgap: 10
            vgap: 20
            rows: [
                Row {
                    cells: Cell {
                        columnSpan: columns
                        content: CalculatorDisplay {
                            text: bind model.display
                            width: 280
                            height: 50
                        }
                    }
                },
                for (i in [0..<(
                    sizeof keyPositionMap / columns)]) {
                    Row {
                        cells:
                        for (j in [0..<columns]) {
                            CalculatorKey {
                                var keyIndex = keyPositionMap[
                                i * columns + j];
                                var keyModel = model.keys[keyIndex];
                                character: keyModel.character
                                action: keyModel.action
                                styleClass: "calculatorKey"
                                id: keyModel.description
                            }
                        }
                    }
                }
            ]
        }
    }
}
