package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;
import com.idesolusiasia.learnflux.util.Functions;

/**
 * Created by NAIT ADMIN on 20/06/2016.
 */
public class Message {


	private String type;
	private String id;

	private Participant sender;
	private String body;
	@SerializedName("created_at")
	private long createdAt;

	boolean readStatus=false;

	public Message() {
	}

	public boolean isReadStatus() {
		return readStatus;
	}

	public void setReadStatus(boolean readStatus) {
		this.readStatus = readStatus;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Participant getSender() {
		return sender;
	}

	public void setSender(Participant sender) {
		this.sender = sender;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public long getCreatedAt() {
		return createdAt;
	}

	public String getCreatedAtDate() {
		return Functions.convertSecondToDate(createdAt);
	}

	public void setCreatedAt(long createdAt) {
		this.createdAt = createdAt;
	}

}
