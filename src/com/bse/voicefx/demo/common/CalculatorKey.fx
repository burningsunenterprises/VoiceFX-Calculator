/*
 * CalculatorKey.fx
 *
 * Derived from SimpleCalc3 application by Dean Iverson as published on the
 * JavaFXpert blog in 2008
 *
 * Large portions of code were Developed in 2008 by Dean Iverson
 * as (a rewrite of James L. Weaver's original example)
 * to demonstrate creating applications using JavaFX SDK 1.0
 */

package com.bse.voicefx.demo.common;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
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
def keyFont = Font { size: 28 }

public class CalculatorKey extends CustomNode {
    public var keyColor = Color.BLACK;
    public var characterColor = Color.YELLOW;
    public-init var character: String;
    public-init var action: function();

    var baseKeyColor = keyColor;
    var highlightColor = baseKeyColor.ofTheWay( Color.WHITE, 0.75 ) as Color;
    var animStartHighlightColor = baseKeyColor;
    var animStartKeyColor = baseKeyColor.ofTheWay( Color.WHITE, 0.75 ) as Color;
    var animEndHighlightColor = baseKeyColor.ofTheWay( Color.WHITE, 0.75 ) as Color;
    var animEndKeyColor= baseKeyColor;

    var background = bind LinearGradient {
        endX: 0.0
        endY: 1.0
        stops: [
            Stop { offset: 0.0 color: keyColor.ofTheWay( Color.WHITE, 0.75 ) as Color },
            Stop { offset: 1.0 color: keyColor },
        ]
    }

    var strokeColor = Color.DIMGRAY;
    var keyFade = Timeline {
        keyFrames: [
            KeyFrame {
                time: 0.0s
                canSkip: false
                values: [
                    strokeColor => Color.WHITE
                    highlightColor => animStartHighlightColor
                    baseKeyColor => animStartKeyColor
                ]
            },
            KeyFrame {
                time: 0.8s
                canSkip: false
                values: [
                    strokeColor => Color.DIMGRAY
                    highlightColor => animEndHighlightColor
                    baseKeyColor => animEndKeyColor
                ]
            }
        ]
    }

    override function create() {
        Group {
            def r:Rectangle = Rectangle {
                width: 60
                height: 40
                arcHeight: 10
                arcWidth: 10
                smooth: true
                stroke: bind strokeColor
                fill: bind LinearGradient {
                    endX: 0.0
                    endY: 1.0
                    stops: [
                        Stop { offset: 0.0 color: highlightColor },
                        Stop { offset: 1.0 color: keyColor },
                    ]
                }
                onMousePressed: function( me:MouseEvent ) {
                    keyFade.playFromStart();
                    action();
                }
            }
            def t:Text = Text {
                translateX: bind (r.width - t.layoutBounds.width) / 2 - t.layoutBounds.minX
                translateY: bind (r.height - t.layoutBounds.height) / 2 - t.layoutBounds.minY
                content: character
                fill: bind characterColor;
                font: keyFont
                textOrigin: TextOrigin.TOP
            }
            content: [ r, t ]
        }
    }
}
