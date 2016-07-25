package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Thread {


	private String id;
	private String title="No Title";
	private String image;
	private String type;
	private boolean isSelected=false;

	private List<Participant> participants;
	/**
	 * type : Message
	 * id : 57737db03a603fc22b3d4d7f
	 * sender : {"id":6,"type":"User","link":"http://lfapp.learnflux.net/user/6"}
	 * body : Helloo
	 * created_at : 1467186608
	 */

	private List<Message> messages;
	private Message lastMessage;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean selected) {
		isSelected = selected;
	}

	public List<Participant> getParticipants() {
		return participants;
	}

	public void setParticipants(List<Participant> participants) {
		this.participants = participants;
	}

	public List<Message> getMessages() {
		return messages;
	}

	public void setMessages(List<Message> messages) {
		this.messages = messages;
	}

	public Message getLastMessage() {
		return lastMessage;
	}

	public void setLastMessage(Message lastMessage) {
		this.lastMessage = lastMessage;
	}
}
