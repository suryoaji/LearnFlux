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
import com.idesolusiasia.learnflux.MyProfileActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.entity.friends;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/18/2016.
 */

public class FriendRequest extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private List<Object>theFriend;
    public Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    private final int FRIENDS =0 , CONTACT=1;

    public FriendRequest(List<Object> alphabet)
    {
        this.theFriend=alphabet;
    }
    @Override
    public int getItemViewType(int position) {
        if (theFriend.get(position) instanceof Contact) {
            return CONTACT;
        } else if (theFriend.get(position) instanceof friends) {
            return FRIENDS;
        }
        return -1;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder holderView;
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        switch (viewType){
            case CONTACT:
                View v1 = inflater.inflate(R.layout.dialog_friendsnotif,parent,false);
                holderView = new viewHolder1(v1);
                break;
            case FRIENDS:
                View v2 = inflater.inflate(R.layout.row_contactplusplus,parent,false);
                holderView = new viewHolder22(v2);
                break;
            default:
                View v = inflater.inflate(android.R.layout.simple_list_item_1, parent, false);
                holderView = new FriendRequest.SimpleText(v);
                break;
        }
        return holderView;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
            switch (holder.getItemViewType()){
                case CONTACT:
                    viewHolder1 vh1 = (viewHolder1)holder;
                    configureViewHolder1(vh1, position);
                    break;
                case FRIENDS:
                    viewHolder22 vh2 = (viewHolder22)holder;
                    configureViewHolder2(vh2,position);
                    break;
                default:
                    FriendRequest.SimpleText vh = (FriendRequest.SimpleText) holder;
                    configureDefaultViewHolder(vh, position);
                    break;
            }
    }

    @Override
    public int getItemCount() {
        return theFriend.size();
    }

    //contact
    public class viewHolder1 extends RecyclerView.ViewHolder {
        NetworkImageView networkImage;
        TextView titleDialog;
        ImageView acceptReq;

        public viewHolder1(View itemView) {
            super(itemView);
            networkImage = (NetworkImageView)itemView.findViewById(R.id.dialogImagee);
            titleDialog = (TextView)itemView.findViewById(R.id.titleDialog);
            acceptReq = (ImageView)itemView.findViewById(R.id.acceptRequest);
        }
        public ImageView getAcceptReq() {
            return acceptReq;
        }

        public void setAcceptReq(ImageView acceptReq) {
            this.acceptReq = acceptReq;
        }


        public NetworkImageView getNetworkImage() {
            return networkImage;
        }

        public void setNetworkImage(NetworkImageView networkImage) {
            this.networkImage = networkImage;
        }

        public TextView getTitleDialog() {
            return titleDialog;
        }

        public void setTitleDialog(TextView titleDialog) {
            this.titleDialog = titleDialog;
        }

    }
    public class viewHolder22 extends RecyclerView.ViewHolder {
        NetworkImageView circularView;
        TextView tvalphabet;
        public viewHolder22(View itemView) {
            super(itemView);
            circularView = (NetworkImageView)itemView.findViewById(R.id.circularView);
            tvalphabet = (TextView)itemView.findViewById(R.id.tv_alphabet);
        }
        public NetworkImageView getCircularView() {
            return circularView;
        }

        public void setCircularView(NetworkImageView circularView) {
            this.circularView = circularView;
        }

        public TextView getTvalphabet() {
            return tvalphabet;
        }

        public void setTvalphabet(TextView tvalphabet) {
            this.tvalphabet = tvalphabet;
        }


    }
    private class SimpleText extends RecyclerView.ViewHolder {

        private TextView label2;


        private SimpleText(View v) {
            super(v);
            label2 = (TextView) v.findViewById(R.id.textNotif2);
        }

        public TextView getLabel() {
            return label2;
        }

        public void setLabel1(TextView label2) {
            this.label2 = label2;
        }
    }
    private void configureDefaultViewHolder(FriendRequest.SimpleText vh, int position) {
        //   vh.getLabel().setText((CharSequence) theContact.get(position));
    }
    private void configureViewHolder1(viewHolder1 v1, final int position){
        String url="http://lfapp.learnflux.net/v1/image?key=";
        final Contact contact = (Contact)theFriend.get(position);
        if(contact==null){
            v1.getTitleDialog().setText("No new friend request");
        }else{
            v1.getTitleDialog().setText(contact.getFirst_name());
            v1.getNetworkImage().setImageUrl(url+contact.getProfile_picture(), imageLoader);
            v1.acceptReq.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View view) {
                    Engine.getUserFriend(view.getContext(), contact.getId(), new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            Toast.makeText(view.getContext(), "Succesfull adding a friend", Toast.LENGTH_SHORT).show();
                            theFriend.remove(position);
                            notifyDataSetChanged();
                        }
                    });
                }
            });
        }
    }
    private void configureViewHolder2(viewHolder22 v22, int position){
        String url="http://lfapp.learnflux.net/v1/image?key=";
        friends friend = (friends) theFriend.get(position);
        if(friend!=null){
           v22.getTvalphabet().setText(friend.getUsername());
            v22.getCircularView().setImageUrl(url+friend.getProfile_picture(),imageLoader);
        }
    }
}
