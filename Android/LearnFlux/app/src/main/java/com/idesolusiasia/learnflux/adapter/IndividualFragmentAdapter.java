package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/13/2016.
 */

public class IndividualFragmentAdapter extends RecyclerView.Adapter<IndividualFragmentAdapter.OrgTileHolder> {
    public List<Participant> participants;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();

    public IndividualFragmentAdapter(Context mContext, ArrayList<Participant> participant)
    {
        this.participants=participant;
        this.context=mContext;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_recycleindividual, null);
        IndividualFragmentAdapter.OrgTileHolder rcv = new IndividualFragmentAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Participant p= participants.get(position);
        holder.individualName.setText(p.getFirstName());
        final String url = "http://lfapp.learnflux.net/v1/image?key="+p.getPhoto();
        holder.circularImage.setImageUrl(url,imageLoader);
    }

    @Override
    public int getItemCount() {
        return participants.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        CircularNetworkImageView circularImage; TextView individualName, individualDesc;

        public OrgTileHolder(View itemView) {
            super(itemView);
            circularImage = (CircularNetworkImageView)itemView.findViewById(R.id.circularImage);
            individualName = (TextView)itemView.findViewById(R.id.individualName);
            individualDesc = (TextView)itemView.findViewById(R.id.txt1Desc);
        }
    }
}
