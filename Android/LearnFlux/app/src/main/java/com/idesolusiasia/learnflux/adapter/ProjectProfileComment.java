package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.R;

/**
 * Created by Ide Solusi Asia on 11/25/2016.
 */

public class ProjectProfileComment extends RecyclerView.Adapter<ProjectProfileComment.ProfileHolder> {

    public Context mContext;

    public ProjectProfileComment(Context context){
        this.mContext=context;
    }


    @Override
    public ProjectProfileComment.ProfileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_profile_comment,null);
        ProfileHolder rcv =  new ProfileHolder(view);
        return rcv;
    }

    @Override
    public void onBindViewHolder(ProjectProfileComment.ProfileHolder holder, int position) {

    }

    @Override
    public int getItemCount() {
        return 0;
    }

    public class ProfileHolder extends RecyclerView.ViewHolder {
        public ProfileHolder(View itemView) {
            super(itemView);
        }
    }
}
