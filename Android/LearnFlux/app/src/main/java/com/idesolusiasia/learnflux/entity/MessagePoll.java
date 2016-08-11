package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

/**
 * Created by NAIT ADMIN on 05/08/2016.
 */
public class MessagePoll extends Message {
	@SerializedName("reference")
	private Poll poll;

	public MessagePoll() {
	}

	public Poll getPoll() {
		return poll;
	}

	public void setPoll(Poll poll) {
		this.poll = poll;
	}
}
