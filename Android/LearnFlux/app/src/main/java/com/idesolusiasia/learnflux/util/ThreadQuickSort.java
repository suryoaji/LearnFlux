package com.idesolusiasia.learnflux.util;

import com.idesolusiasia.learnflux.entity.Thread;

import java.util.List;

/**
 * Created by NAIT ADMIN on 12/08/2016.
 */
public class ThreadQuickSort {

	private List<Thread> array;
	private int length;

	public ThreadQuickSort() {
	}

	public List<Thread> getArray() {
		return array;
	}

	public void sort(List<Thread> inputArr) {

		if (inputArr == null || inputArr.size() == 0) {
			return;
		}
		this.array = inputArr;
		length = inputArr.size();
		quickSort(0, length - 1);
	}

	private void quickSort(int lowerIndex, int higherIndex) {

		int i = lowerIndex;
		int j = higherIndex;
		// calculate pivot number, I am taking pivot as middle index number
		Thread pivot = array.get(lowerIndex+(higherIndex-lowerIndex)/2);
		// Divide into two arrays
		while (i <= j) {
			/**
			 * In each iteration, we will identify a number from left side which
			 * is greater then the pivot value, and also we will identify a number
			 * from right side which is less then the pivot value. Once the search
			 * is done, then we exchange both numbers.
			 */
			while (array.get(i).getLastMessage().getCreatedAt()  > pivot.getLastMessage().getCreatedAt()) {
				i++;
			}
			while (array.get(j).getLastMessage().getCreatedAt() < pivot.getLastMessage().getCreatedAt()) {
				j--;
			}
			if (i <= j) {
				exchangeNumbers(i, j);
				//move index to next position on both sides
				i++;
				j--;
			}
		}
		// call quickSort() method recursively
		if (lowerIndex < j)
			quickSort(lowerIndex, j);
		if (i < higherIndex)
			quickSort(i, higherIndex);
	}

	private void exchangeNumbers(int i, int j) {
		Thread temp = array.get(i);
		array.set(i,array.get(j));
		array.set(j,temp);
	}
}
