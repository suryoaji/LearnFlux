package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by NAIT ADMIN on 05/08/2016.
 */
public class Poll {



	private String id, title, question;
	private String type;
	private List<PollOption> options;
	private List<AnswerData> metadata;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public List<PollOption> getOptions() {
		return options;
	}

	public List<PollOption> getOptionsCount(){
		int total = 0;
		for (PollOption opt:options) {
			opt.setCount(0);
			opt.setPercentage(0);
			for (AnswerData data:metadata) {
				if (opt.getValue().equalsIgnoreCase(data.getAnswer())){
					opt.setCount(opt.getCount()+1);
					total+=1;
				}
			}
		}
		if (total!=0){
			for (PollOption opt:options) {
				opt.setPercentage(((double)opt.getCount()/total)*100);
			}
		}


		return options;
	}

	public void setOptions(List<PollOption> options) {
		this.options = options;
	}

	public List<AnswerData> getMetadata() {
		return metadata;
	}

	public void setMetadata(List<AnswerData> metadata) {
		this.metadata = metadata;
	}

	public String alreadyAnswer(int id){
		for (AnswerData data:metadata) {
			if (data.getUser().getId()==id){
				return  data.getAnswer();
			}
		}
		return null;
	}

	public static class PollOption {
		private String name;
		private String value;
		private int count=0;
		private double percentage=0;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getValue() {
			return value;
		}

		public void setValue(String value) {
			this.value = value;
		}

		public int getCount() {
			return count;
		}

		public void setCount(int count) {
			this.count = count;
		}

		public double getPercentage() {
			return percentage;
		}

		public void setPercentage(double percentage) {
			this.percentage = percentage;
		}
	}

	public static class AnswerData {
		private Participant user;
		@SerializedName("name")
		private String answer;

		public Participant getUser() {
			return user;
		}

		public void setUser(Participant user) {
			this.user = user;
		}

		public String getAnswer() {
			return answer;
		}

		public void setAnswer(String answer) {
			this.answer = answer;
		}
	}
}
