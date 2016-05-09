package com.idesolusiasia.learnflux.entity;

import java.util.Calendar;

/**
 * Created by NAIT ADMIN on 20/04/2016.
 */
public class PlainChatBubble extends ChatBubble {

	private String message;
	private boolean important;
	public PlainChatBubble() {
		super();
	}

	public PlainChatBubble(boolean important, String message) {
		this.important = important;
		this.message = message;
	}

	public PlainChatBubble(String type, String sender, String userPhoto, String userName, Calendar chatCalendar, boolean important, String message) {
		super(type, sender, userPhoto, userName, chatCalendar);
		this.important = important;
		this.message = message;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public boolean isImportant() {
		return important;
	}

	public void setImportant(boolean important) {
		this.important = important;
	}
}
