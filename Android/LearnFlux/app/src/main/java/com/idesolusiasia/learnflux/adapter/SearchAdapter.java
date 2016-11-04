package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.OrgProfileActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/29/2016.
 */

public class SearchAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private List<Object>search;
    public Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    private final int USER=0, GROUP=1;

    public SearchAdapter(List<Object>mSearch){
        this.search=mSearch;
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
        NetworkImageView image;
        TextView txt1, txt2;
        ImageView joinGrp;
        public viewGroup(View itemView) {
            super(itemView);
            image = (NetworkImageView) itemView.findViewById(R.id.imageOrgConnection);
            txt1 = (TextView)itemView.findViewById(R.id.titleOrgConnection);
            txt2 = (TextView)itemView.findViewById(R.id.StatusOrgConnection);
            joinGrp = (ImageView)itemView.findViewById(R.id.joinGroup);
        }
        public ImageView getJoinGrp() {
            return joinGrp;
        }

        public void setJoinGrp(ImageView joinGrp) {
            this.joinGrp = joinGrp;
        }


        public NetworkImageView getImage() {
            return image;
        }

        public void setImage(NetworkImageView image) {
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
            v1.getAdd().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View view) {
                    if (User.getUser().getID() == p.getId()) {
                        Functions.showAlert(view.getContext(), "Message", "You cannot add yourself");
                    } else {
                        Engine.getUserFriend(view.getContext(), p.getId(), new RequestTemplate.ServiceCallback() {
                            @Override
                            public void execute(JSONObject obj) {
                                Toast.makeText(view.getContext(), "Successfull adding a friend", Toast.LENGTH_SHORT).show();
                                search.remove(p);
                                notifyDataSetChanged();
                            }
                        });
                    }
                }
            });
        }
    }
    private void configureViewHolder2(viewGroup v22, final Group g){
        String url="http://lfapp.learnflux.net/v1/image?key=";
        if(g!=null){
            v22.getTxt1().setText(g.getName());
            v22.getImage().setImageUrl(url+g.getImage(),imageLoader);
            v22.getJoinGrp().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View view) {
                    Intent i = new Intent(view.getContext() , OrgProfileActivity.class);
                    i.putExtra("id", g.getId());
                    i.putExtra("title",g.getName());
                    i.putExtra("type", g.getType());
                    view.getContext().startActivity(i);
                   /* Engine.joinGroup(view.getContext(), g.getId(), g.getType(), new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            Toast.makeText(view.getContext(),"Successfull request to join a group", Toast.LENGTH_SHORT).show();
                            search.remove(g);
                            notifyDataSetChanged();
                        }
                    });*/

                }
            });
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
