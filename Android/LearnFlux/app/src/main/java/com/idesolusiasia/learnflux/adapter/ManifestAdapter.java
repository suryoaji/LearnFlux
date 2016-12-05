package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bignerdranch.expandablerecyclerview.Adapter.ExpandableRecyclerAdapter;
import com.bignerdranch.expandablerecyclerview.Model.ParentListItem;
import com.bignerdranch.expandablerecyclerview.ViewHolder.ChildViewHolder;
import com.bignerdranch.expandablerecyclerview.ViewHolder.ParentViewHolder;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.SubcategoryParentListItem;

import java.util.ArrayList;

/**
 * Created by Kuroko on 12/2/2016.
 */

public class ManifestAdapter extends ExpandableRecyclerAdapter<ManifestAdapter.ManifestParentViewHolder, ManifestAdapter.ManifestChildrenViewHolder> {

    private Context mContext;
    public ManifestAdapter(Context context, ArrayList<ParentListItem> parentItemList) {
        super(parentItemList);
        this.mContext=context;
    }

    @Override
    public ManifestParentViewHolder onCreateParentViewHolder(ViewGroup parentViewGroup) {
        View view = LayoutInflater.from(parentViewGroup.getContext()).inflate(R.layout.row_manifest, null);
        ManifestParentViewHolder mpv= new ManifestParentViewHolder(view);
        return mpv;
    }

    @Override
    public ManifestChildrenViewHolder onCreateChildViewHolder(ViewGroup childViewGroup) {
        View view= LayoutInflater.from(childViewGroup.getContext()).inflate(R.layout.row_remarks,null);
        ManifestChildrenViewHolder mcv = new ManifestChildrenViewHolder(view);
        return mcv;
    }

    @Override
    public void onBindParentViewHolder(ManifestParentViewHolder parentViewHolder, int position, ParentListItem parentListItem) {
        SubcategoryParentListItem subcategoryParentListItem = (SubcategoryParentListItem) parentListItem;
        parentViewHolder.titles.setText(subcategoryParentListItem.title);
    }

    @Override
    public void onBindChildViewHolder(ManifestChildrenViewHolder childViewHolder, int position, Object childListItem) {
        SubcategoryParentListItem.SubcategoryChildListItem subcategoryChildListItem = (SubcategoryParentListItem.SubcategoryChildListItem) childListItem;
        childViewHolder.remarks.setText(subcategoryChildListItem.title);
    }

    public class ManifestParentViewHolder extends ParentViewHolder{
        ImageView arrowRemarks;
        TextView titles;
        public ManifestParentViewHolder(View itemView) {
            super(itemView);
            arrowRemarks = (ImageView)itemView.findViewById(R.id.arrowRemarks);
            titles = (TextView)itemView.findViewById(R.id.manifestId);
        }
    }

    public class ManifestChildrenViewHolder extends ChildViewHolder {
        TextView remarks;
        public ManifestChildrenViewHolder(View itemView) {
            super(itemView);
            remarks = (TextView)itemView.findViewById(R.id.remarksText);
        }
    }
}
