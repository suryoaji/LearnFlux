package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 20/04/2016.
 */
public class PlainChatBubble extends ChatBubble {

	private String message;
	public PlainChatBubble() {
		super();
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
