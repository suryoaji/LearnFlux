package com.idesolusiasia.learnflux.entity;

import java.util.ArrayList;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class PollChatBubble {
	private String question, answerStatus, answer;
	private ArrayList<String> choices;

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public String getAnswerStatus() {
		return answerStatus;
	}

	public void setAnswerStatus(String answerStatus) {
		this.answerStatus = answerStatus;
	}

	public ArrayList<String> getChoices() {
		return choices;
	}

	public void setChoices(ArrayList<String> choices) {
		this.choices = choices;
	}
}
