package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.idesolusiasia.learnflux.activity.GroupDetailActivity;
import com.idesolusiasia.learnflux.PublicProfile;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;


import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/29/2016.
 */

public class SearchAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private List<Object>search;
    public Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    private final int USER=0, GROUP=1;

    public SearchAdapter(Context c, List<Object>mSearch){
        this.search=mSearch;
        this.context=c;
    }

    @Override
    public int getItemViewType(int position) {
        if(search.get(position) instanceof Contact){
            return USER;
        }else if(search.get(position)instanceof Group){
            return GROUP;
        }
        return -1;
    }
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        switch(viewType){
            case USER:
                View v1 = inflater.inflate(R.layout.row_recycleindividual,parent,false);
                viewHolder = new viewUser(v1);
                break;
            default:
                View v2 = inflater.inflate(R.layout.row_connectionorg,parent,false);
                viewHolder = new viewGroup(v2);
                break;
        }
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        switch (holder.getItemViewType()){
            case USER:
                viewUser vh1 = (viewUser) holder;
                configureViewHolder1(vh1, (Contact) search.get(position));
                break;
            case GROUP:
                viewGroup vh2 = (viewGroup)holder;
                configureViewHolder2(vh2,(Group) search.get(position));
                break;
        }
    }

    @Override
    public int getItemCount() {
        return search.size();
    }

    public class viewUser extends RecyclerView.ViewHolder {
        CircularNetworkImageView circularImage; TextView individualName, individualDesc;
        ImageView add;
        public viewUser(View itemView) {
            super(itemView);
            circularImage = (CircularNetworkImageView)itemView.findViewById(R.id.circularImage);
            individualName = (TextView)itemView.findViewById(R.id.individualName);
            individualDesc = (TextView)itemView.findViewById(R.id.txt1Desc);
            add = (ImageView)itemView.findViewById(R.id.imageadd);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View v) {
                    int pos = getAdapterPosition();
                    final Contact ct= (Contact)search.get(pos);
                    if(User.getUser().getID()== ct.getId()){
                        Functions.showAlert(v.getContext(), "Message", "You cannot add yourself");
                    }else {
                        Intent i = new Intent(v.getContext(), PublicProfile.class);
                        i.putExtra("id", ct.getId());
                        i.putExtra("public", "search");
                        v.getContext().startActivity(i);
                    }
                }
            });
        }
        public CircularNetworkImageView getCircularImage() {
            return circularImage;
        }

        public void setCircularImage(CircularNetworkImageView circularImage) {
            this.circularImage = circularImage;
        }

        public TextView getIndividualName() {
            return individualName;
        }

        public void setIndividualName(TextView individualName) {
            this.individualName = individualName;
        }

        public TextView getIndividualDesc() {
            return individualDesc;
        }

        public void setIndividualDesc(TextView individualDesc) {
            this.individualDesc = individualDesc;
        }

        public ImageView getAdd() {
            return add;
        }

        public void setAdd(ImageView add) {
            this.add = add;
        }
    }

    public class viewGroup extends RecyclerView.ViewHolder {
        ImageView image;
        TextView txt1, txt2;
        ImageView joinGrp;
        public viewGroup(View itemView) {
            super(itemView);
            image = (ImageView) itemView.findViewById(R.id.imageOrgConnection);
            txt1 = (TextView)itemView.findViewById(R.id.titleOrgConnection);
            txt2 = (TextView)itemView.findViewById(R.id.StatusOrgConnection);
            joinGrp = (ImageView)itemView.findViewById(R.id.joinGroup);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    Group gr = (Group)search.get(pos);
                    Intent i = new Intent(v.getContext() , GroupDetailActivity.class);
                    i.putExtra("id", gr.getId());
                    i.putExtra("img", gr.getImage());
                    i.putExtra("plusButton","show");
                    i.putExtra("clickOrganization", "Default");
                    i.putExtra("title",gr.getName());
                    i.putExtra("type", gr.getType());
                    v.getContext().startActivity(i);
                }
            });
        }
        public ImageView getJoinGrp() {
            return joinGrp;
        }

        public void setJoinGrp(ImageView joinGrp) {
            this.joinGrp = joinGrp;
        }


        public ImageView getImage() {
            return image;
        }

        public void setImage(ImageView image) {
            this.image = image;
        }

        public TextView getTxt1() {
            return txt1;
        }

        public void setTxt1(TextView txt1) {
            this.txt1 = txt1;
        }

        public TextView getTxt2() {
            return txt2;
        }

        public void setTxt2(TextView txt2) {
            this.txt2 = txt2;
        }
    }
    private void configureViewHolder1(viewUser v1, final Contact p){
        String url = "http://lfapp.learnflux.net/v1/image?key=profile/";
        if(p!=null){
            v1.getIndividualName().setText(p.getFirst_name());
            v1.getCircularImage().setImageUrl(url+p.getId(), imageLoader);
            v1.getAdd().setVisibility(View.GONE);
        }
    }
    private void configureViewHolder2(viewGroup v22, final Group g){
        String url="http://lfapp.learnflux.net/v1/image?key=";
        if(g!=null){
            v22.getTxt1().setText(g.getName());
            Animation animation = AnimationUtils.loadAnimation(context,
                    R.anim.popup_enter);
            Ion.with(context)
                    .load(url+g.getImage())
                    .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                    .withBitmap().animateLoad(animation)
                    .intoImageView(v22.getImage());
        }else{
            v22.getImage().setImageResource(R.drawable.company1);
        }
       
    }
    public void clearData() {
        int size = this.search.size();
        if (size > 0) {
            for (int i = 0; i < size; i++) {
                this.search.remove(0);
            }

            this.notifyItemRangeRemoved(0, size);
        }
    }
}
