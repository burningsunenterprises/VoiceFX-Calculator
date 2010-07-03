/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bse.voicefx;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.speech.EngineException;
import javax.speech.EngineStateException;
import javax.speech.recognition.Grammar;
import javax.speech.recognition.GrammarManager;
import javax.speech.recognition.Recognizer;
import javax.speech.recognition.Result;
import javax.speech.recognition.ResultEvent;
import javax.speech.recognition.ResultListener;
import javax.speech.recognition.ResultToken;
import javax.speech.recognition.Rule;
import javax.speech.recognition.RuleAlternatives;
import javax.speech.recognition.RuleGrammar;
import javafx.reflect.*;

/**
 *
 * @author esmith
 */
public class GrammarResolver implements ResultListener {

    private static Logger logger = Logger.getLogger(GrammarResolver.class.getName());
    private GrammarManager grammarManager;
    private String grammarName;
    private static int grammarID = 0;
    private static final String START_RULE_NAME = "start";
    private static HashMap<String, MethodInvoker> eventResolver;

    static {
        eventResolver = new HashMap<String, MethodInvoker>();
    }

    public class MethodInvoker {

        Object instance;
        String method;

        public MethodInvoker(Object i, String m) {
            instance = i;
            method = m;
            dump_instance(i);
        }

        private void dump_instance(Object inst) {
            System.out.println("Dump Instance");
            FXContext ctx = FXContext.getInstance();
            FXClassType cls = ctx.findClass(instance.getClass().getName());
            System.out.println("Class : " + cls);
            List<FXFunctionMember> funcs = cls.getFunctions(true);
            Iterator i = funcs.iterator();
            while (i.hasNext()) {
                FXFunctionMember f = (FXFunctionMember)i.next();
                System.out.println(f.getName());
                f.invoke((FXObjectValue)instance,(FXValue)null);
            }

        }

        public void invoke() {
            Class c = instance.getClass();
            try {
                /*Logger.log(Level.ALL, */System.out.println("Invoking " + method );
                Method m = c.getMethod(method, void.class );
                m.invoke(instance);

            } catch (IllegalAccessException ex) {
                Logger.getLogger(GrammarResolver.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(GrammarResolver.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InvocationTargetException ex) {
                Logger.getLogger(GrammarResolver.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NoSuchMethodException ex) {
                logger.log(Level.SEVERE, null, ex);
            } catch (SecurityException ex) {
                logger.log(Level.SEVERE, null, ex);
            }
        }
    }

    public GrammarResolver(Recognizer recognizer, String commonGrammarName) throws Exception {
        grammarName = commonGrammarName;
        grammarManager = recognizer.getGrammarManager();
        recognizer.addResultListener(this);
    }

    public boolean addGrammarRule(Object instance, String method, String[] tokens)
            throws IllegalArgumentException, EngineStateException, EngineException {
        boolean result = false;
        MethodInvoker mi = new MethodInvoker(instance,method);
        for (int i = 0; i < tokens.length; i++ ) {
            eventResolver.put(tokens[i].trim().toUpperCase(), mi);
            /*Logger.log(Level.ALL, */System.out.println(tokens[i] + " added to event resolver for <" + instance + ">.{"+method+"}");
        }
        RuleGrammar grammar = grammarManager.createRuleGrammar(grammarName + "-" + (grammarID++), START_RULE_NAME);
        grammar.addRule(new Rule(START_RULE_NAME, new RuleAlternatives(tokens), Rule.PUBLIC));
        grammar.addResultListener(this);
        grammar.setActivationMode(Grammar.ACTIVATION_FOCUS);
        grammar.setActivatable(true);
        result = true;

        return result;
    }

    @Override
    public void resultUpdate(ResultEvent event) {
        try {
            logger.info( "Result Event : " + event.paramString() + " : received." );
            if (event.getId() == ResultEvent.RESULT_ACCEPTED) {
                Result result = (Result) (event.getSource());

                StringBuffer buffer = new StringBuffer();
                for (ResultToken token : result.getBestTokens()) {
                    buffer.append(token.getText() + " ");
                }
                String text = buffer.toString().trim().toUpperCase();
                logger.info("Received " + text);

                logger.info( "eventResolver: " + eventResolver );
                boolean key_exists = eventResolver.containsKey(text);
                logger.info( "eventResolver can_resolve " + text + " " +  key_exists );
                if ( key_exists ) {
                    MethodInvoker m = eventResolver.get(text);
                    logger.info("event resolver returns : " + m.toString() );
                    if (null != m) {
                        m.invoke();
                    }
                }
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, e.getLocalizedMessage(), e);
        }
    }

}