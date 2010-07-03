/*
 * CalculatorDisplay.fx
 *
 * Derived from SimpleCalc3 application by Dean Iverson as published on the
 * JavaFXpert blog in 2008
 *
 * Large portions of code were Developed in 2008 by Dean Iverson
 * as (a rewrite of James L. Weaver's original example)
 * to demonstrate creating applications using JavaFX SDK 1.0
 */

package com.bse.voicefx.demo.common;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;

/**
 * @author dean
 * @author eric
 */
public class CalculatorDisplay extends CustomNode {
    public var displayColor = Color.BLACK;
    public var textColor = Color.WHITE;
    public var text: String;
    public var width: Number = 100;
    public var height: Number = 40;

    var background = bind LinearGradient {
        endX: 0.0
        endY: 1.0
        stops: [
            Stop {
                offset: 0.0
                color: displayColor.ofTheWay( Color.WHITE, 0.90 ) as Color
            },
            Stop {
                offset: 0.49
                color: displayColor.ofTheWay( Color.WHITE, 0.10 ) as Color
            },
            Stop { 
                offset: 0.5
                color: displayColor
            },
            Stop {
                offset: 1.0
                color: displayColor.ofTheWay( Color.WHITE, 0.25 ) as Color
            },
        ]
    }

    override function create():Node {
        Group {
            def r:Rectangle = Rectangle {
                width: bind width
                height: bind height
                arcHeight: 2
                arcWidth: 2
                smooth: true
                stroke: Color.DIMGRAY
                fill: bind background
            }
            def t:Text = Text {
                translateX: bind (r.width - t.layoutBounds.width) - t.layoutBounds.minX
                translateY: bind (r.height - t.layoutBounds.height) / 2 - t.layoutBounds.minY
                content: bind text
                fill: bind textColor;
                font: Font {  
                    size: 48
                }
                textOrigin: TextOrigin.TOP
            }
            content: [ r, t ]
        }
    }
}
