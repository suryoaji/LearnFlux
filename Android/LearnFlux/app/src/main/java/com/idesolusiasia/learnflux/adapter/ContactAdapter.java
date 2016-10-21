package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.AllContact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.viethoa.RecyclerViewFastScroller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


/**
 * Created by Ide Solusi Asia on 10/17/2016.
 */

public class ContactAdapter extends RecyclerView.Adapter<ContactAdapter.ViewHolder>
        implements RecyclerViewFastScroller.BubbleTextGetter {

    private List<String>mDataArray;
    public Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    public ContactAdapter(List<String>alphabet)
    {
        this.mDataArray=alphabet;
    }
    @Override
    public int getItemCount() {
        if(mDataArray==null) {
            return 0;
        }
        return mDataArray.size();
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_contact, null);
        ContactAdapter.ViewHolder rcv = new ContactAdapter.ViewHolder(layoutView);
        return rcv;
    }
    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
/*        String url = "http://lfapp.learnflux.net/v1/me/image?key=" + contacts.getProfile_picture();
        holder.title.setText(contacts.getFirst_name());
        holder.circular.setImageUrl(url, imageLoader);*/
        String url = "http://lfapp.learnflux.net/v1/me/image?key=";
        holder.circular.setDefaultImageResId(R.drawable.lasalle_logo);
        holder.title.setText(mDataArray.get(position));
    }


    public String getTextToShowInBubble(int pos) {
        if (pos < 0 || pos >= mDataArray.size())
            return null;

        String name = mDataArray.get(pos);
        if (name == null || name.length() < 1)
            return null;

        return mDataArray.get(pos).substring(0, 1);
    }
    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView title; CircularNetworkImageView circular;
        public ViewHolder(View itemView) {
            super(itemView);
            title = (TextView)itemView.findViewById(R.id.tv_alphabet);
            circular = (CircularNetworkImageView)itemView.findViewById(R.id.circularView);

        }
    }
}
