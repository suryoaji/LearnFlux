package com.idesolusiasia.learnflux.entity;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Thread {


	/**
	 * id : 5756a4763a603fc87dd28363
	 * title : Thread Title
	 * image : https://image.jpg
	 * last_message : {"id":"575a4f373a603fe627d2834a","sender":{"id":7,"name":"Lucy","photo":"https://image.jpg"},"body":"Your Message","created_at":1465536311}
	 * participants : [{"id":7,"name":"tester"},{"id":8,"name":"tester2"},{"id":6,"name":"admin"}]
	 */

	private String id;
	private String title="No Title";
	private String image;
	private String type;
	private boolean isSelected=false;
	/**
	 * id : 575a4f373a603fe627d2834a
	 * sender : {"id":7,"name":"Lucy","photo":"https://image.jpg"}
	 * body : Your Message
	 * created_at : 1465536311
	 */

	private LastMessageEntity last_message;
	/**
	 * id : 7
	 * name : tester
	 */

	private List<ParticipantsEntity> participants;

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

	public LastMessageEntity getLast_message() {
		return last_message;
	}

	public void setLast_message(LastMessageEntity last_message) {
		this.last_message = last_message;
	}

	public List<ParticipantsEntity> getParticipants() {
		return participants;
	}

	public void setParticipants(List<ParticipantsEntity> participants) {
		this.participants = participants;
	}

	public static class LastMessageEntity {
		private String id;
		/**
		 * id : 7
		 * name : Lucy
		 * photo : https://image.jpg
		 */

		private SenderEntity sender;
		private String body;
		private long created_at;
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("dd-MM-yyyy", Locale.US);;

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

		public SenderEntity getSender() {
			return sender;
		}

		public void setSender(SenderEntity sender) {
			this.sender = sender;
		}

		public String getBody() {
			return body;
		}

		public void setBody(String body) {
			this.body = body;
		}

		public String getCreated_at() {
			return simpleDateFormat.format(created_at);
		}

		public void setCreated_at(long created_at) {
			this.created_at = created_at;
		}

		public static class SenderEntity {
			private int id;
			private String name;
			private String photo;

			public int getId() {
				return id;
			}

			public void setId(int id) {
				this.id = id;
			}

			public String getName() {
				return name;
			}

			public void setName(String name) {
				this.name = name;
			}

			public String getPhoto() {
				return photo;
			}

			public void setPhoto(String photo) {
				this.photo = photo;
			}
		}
	}

	public static class ParticipantsEntity {
		private int id;
		private String name;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
	}
}
