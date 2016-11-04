package com.idesolusiasia.learnflux.adapter;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/31/2016.
 */

public class MyProfileInterestAdapter extends RecyclerView.Adapter<MyProfileInterestAdapter.OrgTileHolder>{
    List<String>interest;
    public MyProfileInterestAdapter(List<String>mInterest){
        this.interest=mInterest;
    }

    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_myprofile_userinterest, null);
        MyProfileInterestAdapter.OrgTileHolder rcv = new MyProfileInterestAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
            holder.name.setText(interest.get(position));
    }

    @Override
    public int getItemCount() {
        return interest.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        ImageView img;
        TextView name;
        public OrgTileHolder(View itemView) {
            super(itemView);
            name= (TextView)itemView.findViewById(R.id.interest1);
        }
    }
}
