package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/18/2016.
 */

public class FriendRequest extends RecyclerView.Adapter<FriendRequest.OrgTileHolder> {
    List<User> user;
    Context context;
    public FriendRequest(Context mContext) {
        this.context = mContext;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.dialog_friendsnotif, null);
        FriendRequest.OrgTileHolder rcv = new FriendRequest.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
    }

    @Override
    public int getItemCount() {
        return user.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        TextView name;
        public OrgTileHolder(View itemView) {
            super(itemView);
            name = (TextView)itemView.findViewById(R.id.titleDialog);
        }
    }
}
