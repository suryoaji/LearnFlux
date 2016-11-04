package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.FriendReq;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 11/2/2016.
 */

public class CreateGroupAdapter extends RecyclerView.Adapter<CreateGroupAdapter.ViewHolder> {

     Context mContext;
     List<FriendReq>friendListed;

    public CreateGroupAdapter(Context context, ArrayList<FriendReq> friendListeds){
        this.mContext=context;
        this.friendListed=friendListeds;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_layout, null);
        CreateGroupAdapter.ViewHolder rcv = new CreateGroupAdapter.ViewHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        FriendReq f = friendListed.get(position);
        holder.check.setSelected(f.isSelected());


    }

    @Override
    public int getItemCount() {
        return friendListed.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView name;
        CheckBox check;
        @SuppressWarnings("unused")
        private final String TAG = ViewHolder.class.getSimpleName();
        public ViewHolder(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            name = (TextView)itemView.findViewById(R.id.tvVersionName);
            check =(CheckBox)itemView.findViewById(R.id.checkBox1);
        }

        @Override
        public void onClick(View v) {
            friendListed.get(getLayoutPosition()).setSelected(check.isChecked());
        }
    }
}
