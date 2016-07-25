package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 20/04/2016.
 */
public class PlainChatBubble extends Message {

	private String body;
	private boolean important;
	public PlainChatBubble() {
		super();
	}

	public PlainChatBubble(boolean important, String body) {
		this.important = important;
		this.body = body;
	}

	public PlainChatBubble(long created_at, String id, Participant sender, String type, String body) {
		//super(created_at, id, sender, type);
		super();
		this.body = body;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public boolean isImportant() {
		return important;
	}

	public void setImportant(boolean important) {
		this.important = important;
	}
}
