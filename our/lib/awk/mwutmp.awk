#!/usr/bin/gawk -f

########################################################################
#  mwu : Mann-Whitney U Test : non-parametric rankings of N samples
#  Copyright (C) 2007 Omid Jalali
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
########################################################################

#Usage:		./mwu Fields=10 Key=2,3,6 Performance=9 High=1 Confidence=95 filename

#Notes:		Fields is the total number of fields.
#			Key is the column number(s) of column(s) forming the key.
#			Performance is the column number of the value being measured as the performance measure. It should be a single column.
#			High determines whether a high performance measure is better (High=1) or a low performance measure is better (High=0).
#			Confidence determines the confidence interval. Possible values are 95 and 99 percent.
#			filename is the name of the input file

BEGIN {
	FS = OFS = ",";
	Fields = 2;
	Key = 1;
	Performance = 2;
	High = 0;
	Confidence = 95;
}

NR==1 {
	split(Key,KeyArray,FS);
}

/^$/ || /\#.*/ || NF != Fields {
	#skip blank lines, comments, or lines with wrong number of fields
	next;
}        

{
	#remove spaces and tabs
	gsub(/[ \t]/,"");
	#process the rest
	insertSorted(getKey(KeyArray),$(Performance));
}

function getKey(KeyArray, tempKey,separator)
{
	for(part in KeyArray) 
	{
		tempKey = tempKey separator $KeyArray[part];
		separator="|";
	}
	return tempKey;
}

function insertSorted(key,element)
{
	counter = N[key];
	while (counter >= 1 && PerformanceArray[key,counter] > element)
	{
		PerformanceArray[key,counter+1] = PerformanceArray[key,counter];
		counter--;
	}
		
	PerformanceArray[key,counter+1] = element;
	N[key]++;
}

END {
	for (firstKey in N)
	{
		for (secondKey in N)
		{
			if (firstKey != secondKey)
			{
				#this is to assure that two keys are not compared to each other twice
				newKey = firstKey FS secondKey;
				newKeyReverse = secondKey FS firstKey;
				if (!tempKeyArray[newKey] && !tempKeyArray[newKeyReverse])
				{
					keyCounter++;
					tempKeyArray[newKey] = 1;
					analyze(firstKey, secondKey);
				}
			}
		}
	}
	#print "key,ties,wins,losses";
	for (key in N)
		print key, tie[key]+0, (mywin=winMedianRank[key]+0), (myloss=lossMedianRank[key]+0),mywin-myloss;
}

function analyze(firstKey, secondKey, MergedArray, MergedRanksArray)
{
	#merge them
	for (firstCounter = 1; firstCounter <= N[firstKey]; firstCounter++)
		MergedArray[firstCounter] = PerformanceArray[firstKey,firstCounter];	

	for (secondCounter = 1; secondCounter <= N[secondKey]; secondCounter++)
		MergedArray[firstCounter+secondCounter-1] = PerformanceArray[secondKey,secondCounter];	

	asort(MergedArray);

	#rank them and calculate the sum of ranks
	for (counter = 1; counter <= N[firstKey]+N[secondKey]; counter++)
	{
		sameRankIndex = counter + 1;
		tempIndexSum = counter;
		while (sameRankIndex <= N[firstKey] + N[secondKey] && MergedArray[counter] == MergedArray[sameRankIndex])
		{
			tempIndexSum = tempIndexSum + sameRankIndex;
			sameRankIndex++;
		}
		#decrement by 1 since the last addition did not result in a equality or was out of range
		sameRankIndex--;

		#this means that no ties were seen
		if (sameRankIndex == counter)
		{
			MergedRanksArray[counter] = counter*1.0;
		}
		#this means that there were ties (at least between two of them)
		else
		{
			newRankIndex = tempIndexSum / (sameRankIndex - counter + 1);
			for (tempCounter = counter; tempCounter <= sameRankIndex; tempCounter++)
				MergedRanksArray[tempCounter] = newRankIndex*1.0;
			
			#it should continue from here (already incremented so it is decremented so the main for loop can increment it correctly)
			counter = tempCounter - 1;
		}
	}

	#calculate the sums of ranks for each group
	firstRankSum = 0.0;
	secondRankSum = 0.0;

	firstCounter = 1;
	secondCounter = 1;

	firstOddMedianRank = 0;
	firstEvenMedianRank = 0;
	secondOddMedianRank = 0;
	secondEvenMedianRank = 0;

	for (counter = 1; counter <= N[firstKey]+N[secondKey]; counter++)
	{
		if (firstCounter <= N[firstKey] && MergedArray[counter] == PerformanceArray[firstKey,firstCounter])
		{
			firstRankSum += MergedRanksArray[counter];
		
			#find the medians here while in the loop in case needed later	
			if (N[firstKey] % 2 == 1 && firstCounter == (N[firstKey]+1)/2)
				firstOddMedianRank = MergedRanksArray[counter];
			else if (N[firstKey] % 2 == 0 && firstCounter == N[firstKey]/2)
				firstEvenMedianRank = MergedRanksArray[counter];
			else if (N[firstKey] % 2 == 0 && firstCounter == (N[firstKey]/2)+1)
				firstEvenMedianRank = (firstEvenMedianRank + MergedRanksArray[counter])/2;

			firstCounter++;
		}
		else if (secondCounter <= N[secondKey] && MergedArray[counter] == PerformanceArray[secondKey,secondCounter])
		{
			secondRankSum += MergedRanksArray[counter];

			#find the medians here while in the loop in case needed later	
			if (N[secondKey] % 2 == 1 && secondCounter == (N[secondKey]+1)/2)
				secondOddMedianRank = MergedRanksArray[counter];
			else if (N[secondKey] % 2 == 0 && secondCounter == N[secondKey]/2)
				secondEvenMedianRank = MergedRanksArray[counter];
			else if (N[secondKey] % 2 == 0 && secondCounter == (N[secondKey]/2)+1)
				secondEvenMedianRank = (secondEvenMedianRank + MergedRanksArray[counter])/2;

			secondCounter++;
		}
	}

	#the following two are always true (useful for double checking)
	#firstRankSum = (N[firstKey]+N[secondKey])*(N[firstKey]+N[secondKey]+1)/2 - secondRankSum;
	#secondRankSum = (N[firstKey]+N[secondKey])*(N[firstKey]+N[secondKey]+1)/2 - firstRankSum;

	firstKeyU = firstRankSum - N[firstKey]*(N[firstKey]+1)/2;
	secondKeyU = secondRankSum - N[secondKey]*(N[secondKey]+1)/2;
	
	meanU = N[firstKey]*N[secondKey]/2;
	sdU = (N[firstKey]*N[secondKey]*(N[firstKey]+N[secondKey]+1)/12)^(0.5);

	firstKeyZ = (firstKeyU - meanU)/sdU;
	secondKeyZ = (secondKeyU - meanU)/sdU;

	#since the two keys are equal but different in sign, one is enough to be compared to the critical value 0f 1.960 at 95% confidence or 2.576 at 99%.
	if (firstKeyZ > secondKeyZ)
		Z = firstKeyZ;
	else
		Z = secondKeyZ;

	if (Confidence == 95)
		CriticalValue = 1.960;
	else if (Confidence == 99)
		CriticalValue = 2.576;

	if (Z >= 0 && Z <= CriticalValue) 
	{
		tie[firstKey]++;
		tie[secondKey]++;
	}
	else
	{
		#the rest is used to find win vs. loss based on the median of the ranks

		if (N[firstKey] % 2 == 1)
			firstMedianRank = firstOddMedianRank;
		else
			firstMedianRank = firstEvenMedianRank;

		if (N[secondKey] % 2 == 1)
			secondMedianRank = secondOddMedianRank;
		else
			secondMedianRank = secondEvenMedianRank;

		#If High is 0, it means that lower performance measure is better (winner)
		if (High == 0)
		{
			if (firstMedianRank < secondMedianRank)
			{
				winMedianRank[firstKey]++;
				lossMedianRank[secondKey]++;
			}
			else if (firstMedianRank > secondMedianRank)
			{
				lossMedianRank[firstKey]++;
				winMedianRank[secondKey]++;
			}
			else
			{
				tie[firstKey]++;
				tie[secondKey]++;
			}
		}
	
		#If High is 1, it means that higher performance measure is better (winner)
		else if (High == 1)
		{
			if (firstMedianRank > secondMedianRank)
			{
				winMedianRank[firstKey]++;
				lossMedianRank[secondKey]++;
			}
			else if (firstMedianRank < secondMedianRank)
			{
				lossMedianRank[firstKey]++;
				winMedianRank[secondKey]++;
			}
			else
			{
				tie[firstKey]++;
				tie[secondKey]++;
			}
		}
	}
}