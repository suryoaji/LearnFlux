package com.idesolusiasia.learnflux.entity;

import com.bignerdranch.expandablerecyclerview.Model.ParentListItem;

import java.util.List;

/**
 * Created by Kuroko on 12/2/2016.
 */

public class SubcategoryParentListItem implements ParentListItem {
    public String title;
    private List<SubcategoryChildListItem>mChildItemList;

    public SubcategoryParentListItem(){
        title="SubcategoryParentListItem";
    }
    @Override
    public List<SubcategoryChildListItem>getChildItemList(){
        return mChildItemList;
    }
    public void setChildItemList(List<SubcategoryChildListItem>list){
        mChildItemList = list;
    }
    @Override
    public boolean isInitiallyExpanded(){
        return false;
    }

    public class SubcategoryChildListItem{
        public String title;
        public SubcategoryChildListItem(){
            title = "SubcategoryChildListItem";
        }
    }
}
