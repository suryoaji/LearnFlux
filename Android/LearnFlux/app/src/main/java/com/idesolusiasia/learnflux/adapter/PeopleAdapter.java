package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.ArrayList;
import java.util.List;

public class PeopleAdapter extends ArrayAdapter<Participant> {

    private final List<Participant> participants;
	List<Participant> selectedParticipant;


	public PeopleAdapter(Context context, List<Participant> objects) {
		super(context, R.layout.row_people, objects);
		this.participants=objects;

		selectedParticipant= new ArrayList<>();
	}

	public void setSelected(int position){
		if (selectedParticipant.contains(participants.get(position))){
			selectedParticipant.remove(participants.get(position));
		}else {
			selectedParticipant.add(participants.get(position));
		}
	}

	public Participant getItem(int i){
		if (participants !=null && participants.size()>0 && i>=0){
			return participants.get(i);
		}else return null;
	}

	public void clearSelection(){
		selectedParticipant.clear();
	}

	public List<Participant> getSelectedItems(){
		return selectedParticipant;
	}

	public int[] getSelectedIds(){
		int[] p = new int[selectedParticipant.size()];
		for(int i=0;i<p.length;i++){
			p[i]=selectedParticipant.get(i).getId();
		}
		return p;
	}

	public View getView(int position, View conView, ViewGroup parent){
		PeopleViewHolder holder;
		String url = "http://lfapp.learnflux.net";
		if (conView==null){
			LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			conView= inflater.inflate(R.layout.row_people,null);

			holder = new PeopleViewHolder(conView);
			conView.setTag(holder);
		}else {
			holder = (PeopleViewHolder) conView.getTag();
		}
		ImageLoader imageLoader = VolleySingleton.getInstance(getContext()).getImageLoader();
		Participant p = participants.get(position);
		holder.mItem = participants.get(position);
		holder.tvName.setText(participants.get(position).getFirstName());
		holder.tvName.setTextColor(Color.parseColor("#000000"));
		if(p.get_links()!=null) {
			if (participants.get(position).get_links().getProfile_picture() != null) {
				holder.ivPhoto.setImageUrl(url + participants.get(position).get_links().getProfile_picture().getHref(), imageLoader);
			} else {
				holder.ivPhoto.setDefaultImageResId(R.drawable.user_profile);
			}
		}

		holder.ivCheck.setVisibility((selectedParticipant.contains(participants.get(position))) ? View.VISIBLE : View.GONE);
		holder.relativeLayout.setBackgroundColor((selectedParticipant.contains(participants.get(position))) ? Color.parseColor("#FFCDCDCD") : Color.parseColor("#00ffffff"));

		return conView;
	}

	@Override
	public int getCount() {
		return participants.size();
	}

	public class PeopleViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final NetworkImageView ivPhoto;
        public final TextView tvName;
		public final ImageView ivCheck;
        public Participant mItem;
		public RelativeLayout relativeLayout;

        public PeopleViewHolder(View view) {
            super(view);
            mView = view;
	        ivPhoto = (NetworkImageView) view.findViewById(R.id.ivPhoto);
	        tvName = (TextView) view.findViewById(R.id.tvName);
	        ivCheck = (ImageView) view.findViewById(R.id.ivCheck);
	        relativeLayout = (RelativeLayout) view.findViewById(R.id.relativeLayout);
        }

        @Override
        public String toString() {
            return super.toString() + " '" + tvName.getText() + "'";
        }
    }
}
