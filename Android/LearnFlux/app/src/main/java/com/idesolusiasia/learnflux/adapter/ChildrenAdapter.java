package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Point;
import android.os.Handler;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/29/2016.
 */

public class ChildrenAdapter extends RecyclerView.Adapter<ChildrenAdapter.OrgTileHolder> {
    public List<Contact> contact;
    public Context mContext;
    Point p;
    ImageLoader imageLoader = VolleySingleton.getInstance(mContext).getImageLoader();
    public ChildrenAdapter(Context context, List<Contact> Mcontact){
        this.contact = Mcontact;
        this.mContext= context;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_children, null);
        ChildrenAdapter.OrgTileHolder rcv = new ChildrenAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        Contact c = contact.get(position);
        String urls = "http://lfapp.learnflux.net/v1/image?key=profile/";
        int id = c.getId();
        holder.children.setDefaultImageResId(R.drawable.user_profile);
        holder.children.setImageUrl(urls+id, imageLoader);
    }

    @Override
    public int getItemCount() {
        return contact.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        NetworkImageView children;
        public OrgTileHolder(final View itemView) {
            super(itemView);
            children = (NetworkImageView)itemView.findViewById(R.id.kid1);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int[] location = new int[2];

                    // Get the x, y location and store it in the location[] array
                    // location[0] = x, location[1] = y.
                    children.getLocationOnScreen(location);

                    //Initialize the Point with x, and y positions
                    p = new Point();
                    p.x = location[0];
                    p.y = location[1];


                    final int pos = getAdapterPosition();
                    int popupWidth = 650;
                    int popupHeight = 770;

                    LinearLayout viewGroup = (LinearLayout) itemView.findViewById(R.id.popup);
                    LayoutInflater layoutInflater = (LayoutInflater) mContext
                            .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                    final View layout = layoutInflater.inflate(R.layout.dialog_mychildren, viewGroup);

                    final PopupWindow popup = new PopupWindow(v.getContext());

                    popup.setContentView(layout);
                    popup.setWidth(popupWidth);
                    popup.setHeight(popupHeight);
                    popup.setFocusable(true);
                    final int OFFSET_X = 30;
                    final int OFFSET_Y = 30;

                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            popup.showAtLocation(layout, Gravity.NO_GRAVITY, p.x + OFFSET_X, p.y + OFFSET_Y);
                            NetworkImageView childrenImage= (NetworkImageView)layout.findViewById(R.id.imageChildrenDetail);
                            TextView childName = (TextView)layout.findViewById(R.id.nameOfChild);
                            String urls = "http://lfapp.learnflux.net/v1/image?key=profile/";
                            childName.setText(contact.get(pos).getFirst_name());
                            childrenImage.setDefaultImageResId(R.drawable.user_profile);
                            childrenImage.setImageUrl(urls+contact.get(pos).getId(),imageLoader);
                        }
                    },100L);

                }
            });
        }
    }

}
