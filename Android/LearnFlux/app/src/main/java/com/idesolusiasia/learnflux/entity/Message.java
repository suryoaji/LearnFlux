package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;
import com.idesolusiasia.learnflux.util.Functions;

/**
 * Created by NAIT ADMIN on 20/06/2016.
 */
public class Message {

	/**
	 * type : Message
	 * id : 57737eaa3a603fc02b3d4d7a
	 * sender : {"id":6,"type":"User","link":"http://lfapp.learnflux.net/user/6"}
	 * body : Yoohoooo!🤗
	 * created_at : 1467186858
	 */

	private String type;
	private String id;
	/**
	 * id : 6
	 * type : User
	 * link : http://lfapp.learnflux.net/user/6
	 */

	private Participant sender;
	private String body;
	@SerializedName("created_at")
	private long createdAt;

	boolean readStatus=false;


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

	public String getCreatedAt() {
		return Functions.convertSecondToDate(createdAt);
	}

	public void setCreatedAt(long createdAt) {
		this.createdAt = createdAt;
	}
}
