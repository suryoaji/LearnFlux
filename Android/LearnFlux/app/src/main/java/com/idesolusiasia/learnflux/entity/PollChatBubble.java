//package com.idesolusiasia.learnflux.entity;
//
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.List;
//
///**
// * Created by NAIT ADMIN on 21/04/2016.
// */
//public class PollChatBubble extends ChatBubble {
//	private String question, answerStatus, answer="";
//	private List<String> choices;
//
//	public PollChatBubble(String answerStatus, List<String> choices, String question) {
//		this.answerStatus = answerStatus;
//		this.choices = choices;
//		this.question = question;
//	}
//
//	public PollChatBubble(String type, String sender, String userPhoto, String userName, Calendar chatDate, String answerStatus, List<String> choices, String question) {
//		super(type, sender, userPhoto, userName, chatDate);
//		this.answerStatus = answerStatus;
//		this.choices = choices;
//		this.question = question;
//	}
//
//	public String getQuestion() {
//		return question;
//	}
//
//	public void setQuestion(String question) {
//		this.question = question;
//	}
//
//	public String getAnswer() {
//		return answer;
//	}
//
//	public void setAnswer(String answer) {
//		this.answer = answer;
//	}
//
//	public String getAnswerStatus() {
//		return answerStatus;
//	}
//
//	public void setAnswerStatus(String answerStatus) {
//		this.answerStatus = answerStatus;
//	}
//
//	public List<String> getChoices() {
//		return choices;
//	}
//
//	public void setChoices(ArrayList<String> choices) {
//		this.choices = choices;
//	}
//}
