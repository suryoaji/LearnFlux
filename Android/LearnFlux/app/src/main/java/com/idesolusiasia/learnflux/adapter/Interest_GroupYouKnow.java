package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/11/2016.
 */

public class Interest_GroupYouKnow extends RecyclerView.Adapter<Interest_GroupYouKnow.ItrTileHolder> {
    public Context mContext;
    public ArrayList<Group>interest;

    public Interest_GroupYouKnow(Context context, ArrayList<Group>intrst){
        this.mContext=context;
        this.interest=intrst;
    }

    @Override
    public Interest_GroupYouKnow.ItrTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_interestpeople_know,null);
        ItrTileHolder rcv = new ItrTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(Interest_GroupYouKnow.ItrTileHolder holder, int position) {

    }

    @Override
    public int getItemCount() {
        return interest.size();
    }

    public class ItrTileHolder extends RecyclerView.ViewHolder {
        public ItrTileHolder(View itemView) {
            super(itemView);
        }
    }
}
