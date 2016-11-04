package com.idesolusiasia.learnflux.adapter;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.MyProfileActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/13/2016.
 */

public class IndividualFragmentAdapter extends RecyclerView.Adapter<IndividualFragmentAdapter.OrgTileHolder> {
    public List<Contact> Friends;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();

    public IndividualFragmentAdapter(Context mContext, ArrayList<Contact> mFriends)
    {
        this.Friends=mFriends;
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
        final Contact c= Friends.get(position);
        holder.individualName.setText(c.getFirst_name());
        if(c.get_links().getProfile_picture()!=null) {
            String getProfile = c.get_links().getProfile_picture().getHref();
            final String url = "http://lfapp.learnflux.net" + getProfile;
            holder.circularImage.setImageUrl(url, imageLoader);
        }else{
            holder.circularImage.setDefaultImageResId(R.drawable.user_profile);
        }

        holder.add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View view) {
                int []ids = new int[]{c.getId()};
                Engine.createThread(view.getContext(), ids, c.getFirst_name() ,new RequestTemplate.ServiceCallback() {
                    @Override
                    public void execute(JSONObject obj) {
                        try {
                            String id = obj.getJSONObject("data").getString("id");
                            Intent i = new Intent(view.getContext(), ChattingActivity.class);
                            i.putExtra("idThread", id);
                            i.putExtra("name", c.getFirst_name());
                            context.startActivity(i);
                        }catch (JSONException e){
                            e.printStackTrace();
                        }
                    }
                });
            }
        });
    }

    @Override
    public int getItemCount() {
        return Friends.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        CircularNetworkImageView circularImage; TextView individualName, individualDesc;
        ImageView add;
        public OrgTileHolder(View itemView) {
            super(itemView);
            circularImage = (CircularNetworkImageView)itemView.findViewById(R.id.circularImage);
            individualName = (TextView)itemView.findViewById(R.id.individualName);
            individualDesc = (TextView)itemView.findViewById(R.id.txt1Desc);
            add = (ImageView)itemView.findViewById(R.id.imageadd);
        }
    }

}
